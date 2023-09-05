#@tool
extends Node2D

@export var lifetime: float = 5:
	set(duration):
		lifetime = duration
		if $RemoveTimer:
			$RemoveTimer.wait_time = lifetime


@export var color: Color:
	set(new_color):
		color = new_color
		if Engine.is_editor_hint():
			$Area2D/SplatTex.modulate = new_color

var first_splash = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/SplatTex.modulate = color
	
	$FirstSplahTimer.timeout.connect(after_first_splash)
	
	$RemoveTimer.start()
	$AudioStreamPlayer.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		modulate.a = min(1,$RemoveTimer.time_left)
	

func after_first_splash():
	first_splash = false
	
func on_sheep(obj):
	
	if obj.get_parent() is Sheep:
		if first_splash:
			obj.get_parent().set_color(color, color)
		else:
			obj.get_parent().set_color_bottom(color)
		

func remove():
	queue_free()
