extends StaticBody2D
class_name Slot

var filled = false
var pos = "Default"
var health: float = 0.0
var phys_attack: int = 0
var mag_attack: int = 0
var phys_defense: int = 0
var mag_defense: int = 0
var speed: int = 0
var tags:Array = []
var shift:bool = false

var card_max = 1
var cards_list: Array = []
var accepting: bool = true

var default_color = modulate
var default_size = scale

var highlight_color = Color.GOLD
var highlight_size = Vector2(1.1,1.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize()

func initialize():
	Combat.slots.append(self)

func action():
	if shift:
		cards_list.front().shift()

func place_action(_card):
	update_accepting()

func normalize():
	modulate = default_color
	scale = default_size

func highlight():
	modulate = highlight_color
	scale = highlight_size

func update_accepting():
	if cards_list.size() >= card_max:
		accepting = false
	elif cards_list.size() < card_max and accepting == false:
		accepting = true

func fix_slot() -> void:
	var temp = 0
	normalize()
	for elem in cards_list:
		elem.move_to_front()
		MoveLib.move(elem, global_position + Vector2(0,GlobalVars.stacking_distance)*temp)
		temp = temp + 1
		elem.normalize()
