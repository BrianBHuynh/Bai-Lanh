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

func update_accepting():
	if cards_list.size() >= card_max:
		accepting = false
	elif cards_list.size() < card_max and accepting == false:
		accepting = true
