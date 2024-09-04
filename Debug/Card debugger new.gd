extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(get_parent().slot) and is_instance_valid(get_parent().newSlot):
		text = str(get_parent().slot.cards) + "     " + str(get_parent().newSlot.cards)
	elif is_instance_valid(get_parent().slot):
		text = str(get_parent().slot.cards)
	elif is_instance_valid(get_parent().newSlot):
		text = str(get_parent().newSlot.cards)
	else:
		"No slot"
