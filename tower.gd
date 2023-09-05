
extends Node2D

@export var tower_name: String = "tower"

@export var splat_scale: float = 1.0
@export var splat_lifetime: float = 5.0
@export var lifetime: int = 30

@onready var lifebar = $Area2D/Lifebar
var target

@export var active: bool = false:
	set(new_active):
		active = new_active
		if $Area2D/Splats:
			$Area2D/Splats.visible = active
		if !Engine.is_editor_hint():
			if active:
				sample_targets_on_paths()
				$Timer.start()
			else:
				$Timer.stop()

@export var cost: int = 40

@export var selected: bool = true:
	set(new_selected):
		selected = new_selected
		if $Area2D/Base and active:
			$Area2D/Base.material.set_shader_parameter("visible", new_selected)
		$Range.visible=selected

@export var min_delay_splat: int = 5
@export var max_delay_splat: int = 10

@export var color: Color:
	set(new_color):
		color = new_color
		if $Area2D/Splats:
			$Area2D/Splats.modulate = new_color

		if $Area2D/Base/Path2D/PathFollow2D/Sprite2D:
			$Area2D/Base/Path2D/PathFollow2D/Sprite2D.modulate = new_color

var radius = 100

@onready var map = $/root/Game/Map
@onready var splats = $/root/Game/Splats

var candidate_targets=[]

var splat = preload("res://splat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/Splats.modulate = color

	$Timer.timeout.connect(fire)
	$Timer.wait_time = randi_range(min_delay_splat, max_delay_splat)
	$Timer.start()
	
	var mat = $Area2D/Base.material.duplicate()
	$Area2D/Base.material = mat
	
	$Area2D/Base/Path2D/PathFollow2D.progress_ratio = 0
	
	$DeleteTower.wait_time = lifetime
	$DeleteTower.timeout.connect(delete_tower)

	# generate the list of points that are 'in range' for this tower
	sample_targets_on_paths()

	if candidate_targets.size() == 0:
		print("Paths are out of range. Tower has no candidate target to fire!")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	lifebar.visible = active
	if $DeleteTower.is_stopped():
		lifebar.set_life(100)
	else:
		lifebar.set_life(100 * $DeleteTower.time_left/$DeleteTower.wait_time)

func sample_targets_on_paths():
	
	candidate_targets = []
	
	for path in map.paths.get_children():
		var length = path.curve.get_baked_length()
		for i in range(length):
			#var p = path.get_global_transform() * path.curve.sample_baked(i)
			var p = path.curve.sample_baked(i)
			#print(p)
			#print(global_position)
			if p.distance_to(global_position) < radius:
				candidate_targets.append(p)
			

func fire():

	if candidate_targets.size() > 0:
		
		var p = candidate_targets.pick_random()
		var pos2 = p-$Area2D/Base.global_position
		$Area2D/Base/Path2D.curve.set_point_position(1, p-$Area2D/Base.global_position)
		$Area2D/Base/Path2D/PathFollow2D.visible = true
		
		var tween = get_tree().create_tween()
		tween.tween_property($Area2D/Base/Path2D/PathFollow2D, "progress_ratio", 1, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_callback(create_splat.bind(p))
		
		$Timer.wait_time = randi_range(min_delay_splat, max_delay_splat)

func create_splat(position):
	$Area2D/Base/Path2D/PathFollow2D.visible = false
	$Area2D/Base/Path2D/PathFollow2D.progress_ratio = 0
	
	var s = splat.instantiate()
	s.position = position
	s.scale = Vector2(splat_scale, splat_scale)
	s.lifetime = splat_lifetime
	s.color = color
	s.color.a = 0.8
	splats.add_child(s)

func start_decay():
	$DeleteTower.start()
	
func delete_tower():
	target.active=true
	queue_free()
