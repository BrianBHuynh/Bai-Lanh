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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.slots.append(self)
	modulate = Color(Color.RED, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	if cards_list.size() < max_cap:
		var summon = card_reg.enemy_list.pick_random()
		var instance = summon.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		instance.new_slot = self
		instance.friendly = false
		cards.place_slot_opposing(instance)
		combat.add_initiative(instance)
		cards.fix_slot(self)

func action():
	if shift:
		cards.shift(cards_list.front())

func place_action(card):
	pass
