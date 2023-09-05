extends Node2D

var full_size = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_life(life):
	$Lifebar.region_rect.size.x = full_size * life/100 
