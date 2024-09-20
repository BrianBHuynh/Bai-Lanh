extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://current/scenes/combat/combat_small.tscn")
	get_tree().root.remove_child(Controls.menu)
	Controls.menu_open = false


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://debug/testing.tscn")
	get_tree().root.remove_child(Controls.menu)
	Controls.menu_open = false

func _on_button_3_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().root.remove_child(Controls.menu)
	Controls.menu_open = false
	Combat.clear_data()

func _on_button_4_pressed() -> void:
	for i in 10000:
		Combat.next_turn()
