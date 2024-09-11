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
	if shift:
		cards_list.front().shift()

func place_action(card):
	pass
