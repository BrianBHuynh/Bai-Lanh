extends StaticBody2D

var filled = false
@export var pos = "Default"
@export var health: float = 0.0
@export var phys_attack: int = 0
@export var mag_attack: int = 0
@export var phys_defense: int = 0
@export var mag_defense: int = 0
@export var speed: int = 0
@export var tags:Array = []
@export var shift:bool = false

@export var card_max = 1
var cards_list: Array = []
var accepting: bool = true

var default_color = modulate
var default_size = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Combat.slots.append(self)
	modulate = Color(Color.ALICE_BLUE, .7)

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
