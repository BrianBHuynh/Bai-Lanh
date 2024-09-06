extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_3_pressed() -> void:
	get_tree().root.remove_child(controls.menu)
	controls.menuOpen = false
	combat.clearData()
	get_tree().reload_current_scene()


func _on_button_4_pressed() -> void:
	for i in 10:
		combat.nextTurn()

func _on_button_pressed() -> void:
	get_tree().root.remove_child(controls.menu)
	controls.menuOpen = false
	get_tree().change_scene_to_file("res://Current/Scenes/Combat/combatSmall.tscn")


func _on_button_2_pressed() -> void:
	get_tree().root.remove_child(controls.menu)
	controls.menuOpen = false
	get_tree().change_scene_to_file("res://Debug/Testing.tscn")
