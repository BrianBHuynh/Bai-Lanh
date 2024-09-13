extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "Health: " + str(get_parent().health) + "\n"
	if get_parent().pref_pos.has(get_parent().pos):
		text = text + "Position buff activated \n"
	if get_parent().shifted:
		text = text + "Shifted\n"
