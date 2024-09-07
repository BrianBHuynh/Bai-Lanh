extends StaticBody2D

var filled = false
var pos = "Default"
var pos_health = 100
var pos_attack = 10
var pos_defense = 0
var pos_speed = 0

var cards_list: Array = []
var accepting: bool = true

var default_color = modulate
var default_size = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.slots.append(self)
	modulate = Color(Color.ALICE_BLUE, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not cards_list.is_empty():
		accepting = false
	elif cards_list.is_empty() and accepting == false:
		accepting = true

func action():
	pass #this type has no actions
