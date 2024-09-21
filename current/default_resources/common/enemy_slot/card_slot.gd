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
var accepting: bool = false

var max_cap = 1

var default_color = Color(Color.RED, .7)
var default_size = scale

var summoned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Combat.slots.append(self)
	modulate = Color(Color.RED, .7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not summoned:
		var summon: Card = load(CardReg.enemy_list.pick_random()).instantiate()
		summon.position = position
		get_parent().add_child(summon)
		summon.new_slot = self
		summon.friendly = false
		summon.initialize()
		Cards.place_slot_opposing(summon)
		Cards.fix_slot(self)
		summoned = true

func action():
	if shift:
		Cards.shift(cards_list.front())

func place_action(_card):
	pass
