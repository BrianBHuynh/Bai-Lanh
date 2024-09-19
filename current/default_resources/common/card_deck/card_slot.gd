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

var max_cap = 7
var drawn = 0

var default_color = Color(Color.GRAY, .7)
var default_size = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Combat.slots.append(self)
	modulate = Color(Color.GRAY, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	for i in 1000:
		var summon: Card = load(CardReg.ally_list.pick_random()).instantiate()
		summon.position = position
		get_parent().add_child(summon)
		summon.new_slot = self
		Cards.place_draw_pile(summon)
		Cards.fix_slot(self)
		drawn = drawn+1

func action():
	if shift:
		Cards.shift(cards_list.front())

func place_action(card):
	pass
