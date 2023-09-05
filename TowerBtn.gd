@tool
extends MarginContainer

signal pressed

@export var texture: Texture:
	set(tex):
		texture = tex
		if $VBox/Button:
			$VBox/Button.texture_normal = tex

@export var texture_pressed: Texture:
	set(tex):
		texture_pressed = tex
		if $VBox/Button:
			$VBox/Button.texture_pressed = tex

@export var has_label: bool = true:
	set(val):
		has_label = val
		$VBox/Label.visible = val

var available = true
var cost

@export var target_tower: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if target_tower:
		var t = target_tower.instantiate()
		cost = t.cost
		$VBox/Label.text = t.tower_name + "\n" + str(cost)
	else:
		cost = 0

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_pressed():
	if available:
		pressed.emit()

func set_available_money(money):
	available = money >= cost
	$Impossible.visible = not available
		
