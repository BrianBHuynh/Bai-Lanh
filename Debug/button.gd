extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if is_instance_valid(combat.playerParty.front()):
		combat.playerParty.front().curSlot.filled = false
		combat.playerParty.pop_front().free()
	else:
		get_tree().change_scene_to_file("res://Debug/Testing.tscn")
