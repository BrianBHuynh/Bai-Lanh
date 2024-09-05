extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if combat.playerParty.is_empty() or combat.opposingParty.is_empty():
		
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Debug/Testing.tscn")
	else:
		combat.nextTurn()
