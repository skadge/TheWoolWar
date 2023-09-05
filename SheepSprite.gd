extends Node2D

var old_pos

var dir1 = Vector2(128,64/2).normalized()
var dir2 = Vector2(128,-64/2).normalized()

# Called when the node enters the scene tree for the first time.
func _ready():
	old_pos = get_parent().position
	
	$Sprite.play()
	

func set_color(top, bottom):
	$BottomMask.modulate = bottom
	$TopMask.modulate = top
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dp = (get_parent().position - old_pos).normalized()
	
	var dirA = dir1.dot(dp)
	var dirB = dir2.dot(dp)
		
	if abs(dirA) < abs(dirB) and dirA > 0:
		$Sprite.play("nw")
		$BottomMask.set_frame(1)
		$TopMask.set_frame(1)
	if abs(dirA) < abs(dirB) and dirA < 0:
		$Sprite.play("se")
		$BottomMask.set_frame(3)
		$TopMask.set_frame(3)
	if abs(dirA) > abs(dirB) and dirA > 0:
		$Sprite.play("sw")
		$BottomMask.set_frame(0)
		$TopMask.set_frame(0)
	if abs(dirA) > abs(dirB) and dirA < 0:
		$Sprite.play("ne")
		$BottomMask.set_frame(2)
		$TopMask.set_frame(2)
		
	old_pos = get_parent().position
