extends Control

signal new_round

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_scores(scores, colors, names):
	
	var sorted_scores = scores.duplicate()
	sorted_scores.sort()
	sorted_scores.reverse()
	
	var entries = [$CenterContainer/VBoxContainer/Gold,
					$CenterContainer/VBoxContainer/Silver,
					$CenterContainer/VBoxContainer/Bronze,
					$CenterContainer/VBoxContainer/Chocolate
	]
	
	for idx in range(sorted_scores.size()):
		var score = sorted_scores[idx]
		var ridx = scores.find(score)
		var entry = entries[idx]
		entry.get_node("Label").text = names[ridx] + " a tondu " + str(score) + " moutons"
		entry.get_node("Color").color = colors[ridx]

func next_round():
	new_round.emit()

func exit():
	get_tree().quit()
