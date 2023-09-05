extends Control

@onready var countdown = $Countdown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_first_player(name, color):
	
	$ActivePlayerBox/ActivePlayer.text = name + " tond en premier!"
	var new_stylebox_normal = $ActivePlayerBox/ActivePlayer.get_theme_stylebox("normal").duplicate()
	color.a = 0.6
	new_stylebox_normal.bg_color = color
	$ActivePlayerBox/ActivePlayer.add_theme_stylebox_override("normal", new_stylebox_normal)
	
	var tween = get_tree().create_tween()
	#tween.tween_property(get_parent(), "theme_override_constants/margin_bottom", 10, 3)
	tween.parallel().tween_property($ActivePlayerBox/ActivePlayer, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($ActivePlayerBox/ActivePlayer, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($ActivePlayerBox/ActivePlayer, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($ActivePlayerBox/ActivePlayer, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
