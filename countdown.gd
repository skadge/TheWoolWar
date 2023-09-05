extends CenterContainer
signal timeout

@onready var label = $Label
@export var duration = 10

@export var warn_from = 5
@export var alert_from = 3

var current = duration

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# initially hidden!
	label.visible = false
	
	$Timer.timeout.connect(update)
	$Timer.wait_time = 1
	#start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	current = duration
	label.visible = false
	$Timer.stop()
	
func start():
	current = duration
	label.add_theme_color_override("font_color", Color.DARK_ORANGE)
	label.add_theme_color_override("font_outline_color", Color.DARK_ORANGE)
	label.add_theme_font_size_override("font_size", 60)
	
	label.text = str(current)
	label.visible = true
	

	$Timer.start()
	
	
func update():
	current -= $Timer.wait_time

	if current == -1:
		timeout.emit()
		$Timer.stop()
		label.visible = false
		
	else:
		label.text = str(current)
	
		if current <= warn_from:
			label.add_theme_color_override("font_outline_color", Color.CRIMSON)
		if current <= alert_from:
			label.add_theme_font_size_override("font_size", 100)
			label.add_theme_color_override("font_color", Color.CRIMSON)
		


