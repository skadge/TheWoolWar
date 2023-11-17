extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player(name):
	text = name
	#var new_stylebox_normal = get_theme_stylebox("normal").duplicate()
	#color.a = 0.6
	#new_stylebox_normal.bg_color = color
	#add_theme_stylebox_override("normal", new_stylebox_normal)
	
	var tween = get_tree().create_tween()
	#tween.tween_property(get_parent(), "theme_override_constants/margin_bottom", 10, 3)
	tween.parallel().tween_property(self, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	tween.tween_callback(get_node("../Countdown").start)
