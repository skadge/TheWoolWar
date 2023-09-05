extends Node2D

signal new_item


var dist = []

var type

# Called when the node enters the scene tree for the first time.
func _ready():
	create_distribution()
	type = dist.pick_random()
	
	$Timer.wait_time = 5
	$Timer.timeout.connect(delete)
	$Timer.start()


func create_distribution():
	for k in Globals.SURPRISE_DISTRIBUTION:
		var prob = int(Globals.SURPRISE_DISTRIBUTION[k] * 100)
		for i in range(prob):
			dist.append(k)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_present():
	
	new_item.emit(type)
	
	queue_free()

func delete():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
