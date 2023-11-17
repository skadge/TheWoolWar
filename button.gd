extends TextureButton


@onready var label = $Label

@export var text: String

	
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
