extends Control

@onready var start_btn = $NinePatchRect/Button
@onready var player1_label = $VBoxContainer/Player1/NameEdit
@onready var player2_label = $VBoxContainer/Player2/NameEdit
@onready var player3_label = $VBoxContainer/Player3/NameEdit
@onready var player4_label = $VBoxContainer/Player4/NameEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_colors(colors):
	$VBoxContainer/Player1/TextureRect.modulate = colors[0]
	$VBoxContainer/Player2/TextureRect.modulate = colors[1]
	$VBoxContainer/Player3/TextureRect.modulate = colors[2]
	$VBoxContainer/Player4/TextureRect.modulate = colors[3]
