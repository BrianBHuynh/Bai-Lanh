extends Control
var fast_forward_turns: int = 1000
var current_turns: int = 0
var even = true
var ticking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ticking and current_turns < fast_forward_turns:
		if even:
			current_turns = current_turns + 1
			Combat.next_turn()
	elif ticking == true:
		ticking = false
		current_turns = 0
	if even:
		even = false
	else:
		even = true

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
	ticking = true
