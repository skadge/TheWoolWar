class_name Sheep
extends PathFollow2D

@onready var sheep = $ColoredSheep

const speed = 100
var speed_factor = 1


var top_color = Color.TRANSPARENT
var bottom_color = Color.TRANSPARENT

var landed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_color(top_color, bottom_color)
	
	h_offset = randi_range(-10,10)
	v_offset = randi_range(-10,10)
	
	progress_ratio = 0
	
	down_from_sky()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if landed:
		progress += delta * speed * speed_factor
	

func set_color_bottom(bottom:Color):
	$SoundEffects.get_children().pick_random().play()
	bottom.a = 0.8
	bottom_color=bottom
	sheep.set_color(top_color, bottom_color)

	
func set_top_color(top:Color):
	$SoundEffects.get_children().pick_random().play()
	top.a = 0.8
	top_color=top
	sheep.set_color(top_color, bottom_color)
	
func set_color(top, bottom):
	$SoundEffects.get_children().pick_random().play()
	bottom.a = 0.8
	top.a = 0.8
	bottom_color=bottom
	top_color=top
	sheep.set_color(top_color, bottom_color)

func down_from_sky():
	speed_factor = 0
	var tween = get_tree().create_tween()
	sheep.position.y -= 200
	sheep.modulate.a = 0
	tween.tween_property(sheep, "position:y", sheep.position.y + 200, 1).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sheep, "modulate:a", 1, 1)
	tween.tween_callback(self.set_speed_factor)

func set_speed_factor():
	speed_factor = randf_range(0.5,1)
	landed = true
	
func exit_to_sky():
	$Particles.visible = true
	speed_factor = 0
	var tween = get_tree().create_tween()
	tween.tween_property(sheep, "position:y", sheep.position.y - 200, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(sheep, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(self.queue_free)
