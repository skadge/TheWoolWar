extends Node2D

signal remaining_sheep_count_changed
signal scores_changed
signal building_complete
signal game_over

@onready var map = $Map
@onready var splats = $Splats
@onready var buildings = $Buildings

@onready var surprises = $Surprises


@onready var UI = $UILayer/UI
@onready var StartScreen = $UILayer/LaunchUI
@onready var CountdownScreen = $UILayer/LaunchCountdown
@onready var FinalScores = $UILayer/FinalScores

var monster = preload("res://Monster.tscn")
var surprise = preload("res://surprise.tscn")

var splat = preload("res://splat.tscn")
var tower1 = preload("res://tower.tscn")
var tower2 = preload("res://tower2.tscn")

const NB_SHEEPS = 100
var nb_sheeps_remaining = NB_SHEEPS

var nb_players = 4

var players_colors = [
				Color.CRIMSON,
				Color.DARK_ORANGE,
				Color.DARK_MAGENTA,
				Color.FOREST_GREEN]

var players_names

const START_MONEY = 50
var players_money = [START_MONEY,START_MONEY,START_MONEY,START_MONEY]
var players_scores = [0,0,0,0]

var play_order = [0,1,2,3]

var player_idx = 0
var active_player

var surprises_targets = []

const half_sheep_value = 5
const full_sheep_value = 15

var round_idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	StartScreen.set_colors(players_colors)
	play_order.shuffle()
	
	$SheepGeneratorTimer.timeout.connect(spawn_sheep)
	$SheepGeneratorTimer.stop()
	
	$SurpiseSpawningTimer.timeout.connect(spawn_surprise)
	$SurpiseSpawningTimer.stop()
	
	map.sheep_exit.connect(on_sheep_exit)
	
	FinalScores.new_round.connect(on_next_round)
	
	remaining_sheep_count_changed.connect(UI.on_count_updated)
	remaining_sheep_count_changed.emit(nb_sheeps_remaining)
	
	scores_changed.connect(UI.on_scores_updated)
	scores_changed.emit(players_colors, players_money, players_scores, active_player)
	
	building_complete.connect(UI.buildings.hide_cancel)
	
	StartScreen.start_btn.pressed.connect(start_game)
	
	UI.buildings.building_created.connect(on_new_building)
	UI.countdown.timeout.connect(on_countdown_over)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_next_round():
	round_idx = -1
	player_idx = 0
	nb_sheeps_remaining = NB_SHEEPS
	
	for building in $Buildings.get_children():
		building.delete_tower()
	
	map.clear_sheeps()
	
	play_order.shuffle()
	players_money = [START_MONEY,START_MONEY,START_MONEY,START_MONEY]
	scores_changed.emit(players_colors, players_money, players_scores, active_player)
	start_game()
	
func start_game():
	players_names = [StartScreen.player1_label.text,
					StartScreen.player2_label.text,
					StartScreen.player3_label.text,
					StartScreen.player4_label.text]
	
	FinalScores.visible=false
	StartScreen.visible = false
	CountdownScreen.visible = true
	CountdownScreen.set_first_player(players_names[play_order[1]], players_colors[play_order[1]])
	CountdownScreen.countdown.start()
	
	await CountdownScreen.countdown.timeout
	
	$SurpiseSpawningTimer.wait_time = randf_range(3,5)
	$SurpiseSpawningTimer.start()
	
	CountdownScreen.visible = false
	UI.visible = true
	next_active_player()
	
func _input(event):

	if $ActiveBuilding.get_children().size() != 0:
		
		var building = $ActiveBuilding.get_child(0)
		
		var active_target
		
		var snapped = false
		for target in map.targets.get_children():
			if target.active and (target.position - get_global_mouse_position()).length() < 50:
				building.position = target.position
				active_target = target
				snapped = true
				break
			
		if not snapped:
			building.position = get_global_mouse_position()
		
		else:
			if event is InputEventMouseButton and event.is_pressed():
				#print("mouse button event at ", get_global_mouse_position())
				
				if players_money[active_player] >= building.cost:

					active_target.active = false
					building.reparent(buildings)
					building.color = players_colors[active_player]
					building.active = true
					if round_idx > 0:
						building.start_decay()
					building.target = active_target
					players_money[active_player] -= building.cost
					next_active_player()
					scores_changed.emit(players_colors, players_money, players_scores, active_player)
					building_complete.emit()


func spawn_sheep():
	var m = monster.instantiate()
	map.paths.get_children().pick_random().add_child(m)
	$SheepGeneratorTimer.wait_time = randf_range(0.5,1.7)
	$SheepGeneratorTimer.start()

func sample_surprise_targets_on_paths():
	
	for i in range(30):
		var path = map.paths.get_children().pick_random()
		var length = path.curve.get_baked_length()
		var p = path.curve.sample_baked(randf_range(length * .2, length - length * .2))
		surprises_targets.append(p)
			
func spawn_surprise():
	
	if surprises_targets.size() == 0:
		sample_surprise_targets_on_paths()
		
	var s = surprise.instantiate()
	s.position = surprises_targets.pick_random()
	surprises.add_child(s)
	
func on_sheep_exit(sheep):
	print("Sheep is leaving!")
	nb_sheeps_remaining -= 1
	
	if nb_sheeps_remaining == 0:
		game_over.emit()
		UI.visible = false
		$SheepGeneratorTimer.stop()
		$SurpiseSpawningTimer.stop()
	
		$UILayer/FinalScores.set_scores(players_scores, players_colors, players_names)
		
		for building in $Buildings.get_children():
			building.active = false
			
		FinalScores.visible = true
	
	var top : Color = sheep.top_color
	top.a = 1.0
	var bottom : Color = sheep.bottom_color
	bottom.a = 1.0
	
	if FinalScores.visible == false:
		if top == bottom and top in players_colors:
			players_money[players_colors.find(top)] += full_sheep_value
			players_scores[players_colors.find(top)] += 1
		else:
			if top in players_colors:
				players_money[players_colors.find(top)] += half_sheep_value
				players_scores[players_colors.find(top)] += 1
			if bottom in players_colors:
				players_money[players_colors.find(bottom)] += half_sheep_value
				players_scores[players_colors.find(bottom)] += 1
		
		#print(players)
		remaining_sheep_count_changed.emit(nb_sheeps_remaining)
		scores_changed.emit(players_colors, players_money, players_scores, active_player)
	
	sheep.exit_to_sky()

func next_active_player():
	UI.countdown.reset()
	player_idx = (player_idx + 1) % nb_players
	
	if player_idx == 1:
		round_idx += 1
	if round_idx == 1 and player_idx == 1:
			$SheepGeneratorTimer.start()
			for building in $Buildings.get_children():
				building.start_decay()
			
	active_player = play_order[player_idx]
	#$AudioStreamPlayer.play()
	scores_changed.emit(players_colors, players_money, players_scores, active_player)
	UI.set_active_player(players_names[active_player], players_colors[active_player])
	
	
func on_countdown_over():
	for b in $ActiveBuilding.get_children():
			b.queue_free()
	UI.buildings.hide_cancel()
	next_active_player()
	#UI.countdown.start()
	
func on_new_building(type):
	
	if type == "tower1":
		var building = tower1.instantiate()
		building.active = false
		$ActiveBuilding.add_child(building)
		
	if type == "tower2":
		var building = tower2.instantiate()
		building.active = false
		$ActiveBuilding.add_child(building)
	
	if type == "cancel":
		for b in $ActiveBuilding.get_children():
			b.queue_free()
