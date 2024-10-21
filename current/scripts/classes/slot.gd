extends StaticBody2D
class_name Slot

var filled: bool = false
var pos: String = "Default"
var health: float = 0.0
var phys_attack: float = 0
var mag_attack: float = 0
var phys_defense: float = 0
var mag_defense: float = 0
var speed: int = 0
var tags:Array = []
var shift:bool = false

var card_max: int = 1
var cards_list: Array = []
var accepting: bool = true

var default_color: Color = modulate
var default_size: Vector2 = scale

var highlight_color: Color = Color.GOLD
var highlight_size: Vector2 = Vector2(1.1,1.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize()

func initialize() -> void:
	Combat.slots.append(self)

func action() -> void:
	if shift:
		cards_list.front().shift()

func place_action(_card: Card) -> void:
	pass

func normalize() -> void:
	modulate = default_color
	scale = default_size

func highlight() -> void:
	modulate = highlight_color
	scale = highlight_size

func update_accepting() -> void:
	if cards_list.size() >= card_max:
		accepting = false
	elif cards_list.size() < card_max and accepting == false:
		accepting = true

func fix_slot() -> void:
	var temp: int = 0
	normalize()
	for elem: Card in cards_list:
		elem.move_to_front()
		MoveLib.move(elem, global_position + Vector2(0,GlobalVars.stacking_distance)*temp)
		elem.current_position = global_position + Vector2(0,GlobalVars.stacking_distance)*temp
		temp = temp + 1
		elem.normalize()
