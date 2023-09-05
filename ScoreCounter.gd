extends HBoxContainer

@onready var sheeps = $HBoxContainer/Sheeps
@onready var money = $HBoxContainer/Money


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color(color: Color):
	$TextureRect.modulate = color

func set_score(money_amount: int, score: int):
	sheeps.text = str(score)
	money.text = str(money_amount)

func set_active(active: bool):
	if active:
		sheeps.add_theme_font_size_override("font_size", 30)
		#sheeps.add_theme_color_override("font_outline_color", Color.BLACK)
		#sheeps.add_theme_constant_override("outline_size", 10)
		money.add_theme_font_size_override("font_size", 30)
		#money.add_theme_color_override("font_outline_color", Color.BLACK)
		#money.add_theme_constant_override("outline_size", 10)
	else:
		sheeps.remove_theme_font_size_override("font_size")
		#sheeps.remove_theme_color_override("font_outline_color")
		#sheeps.remove_theme_constant_override("outline_size")
		money.remove_theme_font_size_override("font_size")
		#money.remove_theme_color_override("font_outline_color")
		#money.remove_theme_constant_override("outline_size")
