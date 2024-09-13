extends Node

var menu: Node
var menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu = preload("res://current/scenes/menu/escape_menu/escape_menu.tscn").instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if not menu_open:
			get_tree().root.add_child(menu)
			menu_open = true
		else:
			get_tree().root.remove_child(menu)
			menu_open = false
