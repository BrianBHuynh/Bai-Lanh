extends Area2D

var health = 100 #health amount of player
var attack = 20 #attack value of the player
var defense = 20 #defense of the player
var pref_pos = "None" #prefered possition of the player
var draggable = false
var slotted = 0
var Slot_ref
var offset: Vector2
var Initialpos: Vector2
var Cur_ref
var Defaultcolor = modulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("Left_click"):
			offset = get_global_mouse_position() - global_position
			Initialpos = global_position
			GlobalVars.dragging_card = true
			move_to_front()
		if Input.is_action_pressed("Left_click"):
			global_position = get_global_mouse_position() - offset
			modulate = Color(Color.LIGHT_GOLDENROD, 1.5);
		elif Input.is_action_just_released("Left_click"):
			modulate = Defaultcolor;
			GlobalVars.dragging_card = false
			var tween = get_tree().create_tween()
			if slotted > 0 && is_instance_valid(Slot_ref) && not Slot_ref.filled:
				tween.tween_property(self,"position",Slot_ref.position,0.2).set_ease(Tween.EASE_OUT)
				if is_instance_valid(Cur_ref):
					Cur_ref.filled = false
				Cur_ref = Slot_ref
				Cur_ref.filled = true
			else:
				tween.tween_property(self,"global_position",Initialpos,0.2).set_ease(Tween.EASE_OUT)
				slotted = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		slotted = slotted + 1
		body.modulate = Color(Color.WHITE, 2)
		body.scale = Vector2(1.1,1.1)
		Slot_ref = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		slotted = slotted - 1
		body.modulate = Color(Color.ALICE_BLUE, .7)
		body.scale = Vector2(1,1)


func _on_mouse_entered() -> void:
	if not GlobalVars.dragging_card:
		draggable = true
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.WHITE, 1)


func _on_mouse_exited() -> void:
	if not GlobalVars.dragging_card:
		draggable = false
		scale = Vector2(1,1)
		modulate = Defaultcolor
