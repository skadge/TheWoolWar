extends Control

@onready var sheep_counter = $VBoxContainer/HBoxContainer/Label 

@onready var player1 = $VBoxContainer/ScoresContainer/Player1
@onready var player2 = $VBoxContainer/ScoresContainer/Player2
@onready var player3 = $VBoxContainer/ScoresContainer/Player3
@onready var player4 = $VBoxContainer/ScoresContainer/Player4

@onready var buildings = $HBoxContainer/TowersBar
@onready var countdown = $Countdown
@onready var active_player_label = $ActivePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_count_updated(count):
	sheep_counter.text = "Encore " + str(count) + " moutons à tondre!"

func on_scores_updated(colors, money, score, active_player):

	var players = [player1,player2,player3,player4]
	
	for i in range(players.size()):
		players[i].set_color(colors[i])
		players[i].set_score(money[i], score[i])
		
		if i == active_player:
			players[i].set_active(true)
		else:
			players[i].set_active(false)
	
	if active_player != null:
		buildings.update_money(money[active_player])

func set_active_player(name, color:Color):
	$Border.modulate = color
	$Border.modulate.a = 0.6
	
	active_player_label.set_player(name)
	
