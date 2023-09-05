@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2i(0,0),get_parent().radius,Color.from_hsv(0.1,0.8,0.7,0.2))
	draw_arc(Vector2i(0,0),get_parent().radius,0,TAU,50,Color.from_hsv(0.1,0.8,0.4,0.5),1.0,true)
