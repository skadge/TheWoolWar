extends Node2D
signal sheep_exit

@onready var targets = $BuildingTargets
@onready var paths = $Terrain/Paths

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clear_sheeps():
	for path in paths.get_children():
		for sheep in path.get_children():
			sheep.queue_free()
