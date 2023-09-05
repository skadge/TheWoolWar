extends HBoxContainer

signal building_created

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tower1Btn.pressed.connect(tower_selected.bind("tower1"))
	$Tower2Btn.pressed.connect(tower_selected.bind("tower2"))
	$CancelBtn.pressed.connect(cancel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func tower_selected(type):
	
	for btn in get_children():
		btn.visible = false
		
	$CancelBtn.visible = true
	
	building_created.emit(type)

func cancel():
	for btn in get_children():
		btn.visible = true
		
	$CancelBtn.visible = false
	
	building_created.emit("cancel")

func hide_cancel():
	for btn in get_children():
		btn.visible = true
		
	$CancelBtn.visible = false

func update_money(money):
	for btn in get_children():
		btn.set_available_money(money)

