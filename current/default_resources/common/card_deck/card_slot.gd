extends StaticBody2D

var filled = false
@export var pos = "Default"
@export var health: int = 0
@export var phys_attack: int = 0
@export var mag_attack: int = 0
@export var phys_defense: int = 0
@export var mag_defense: int = 0
@export var speed: int = 0
@export var tags:Array = []

var cards_list: Array = []
var accepting: bool = false

var max_cap = 7
var drawn = 0

var default_color = Color(Color.GRAY, .7)
var default_size = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.slots.append(self)
	modulate = Color(Color.GRAY, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	if drawn < max_cap:
		var summon = card_reg.ally_list.duplicate().pick_random()
		var instance = summon.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		instance.new_slot = self
		cards.place_draw_pile(instance)
		cards.fix_slot(self)
		drawn = drawn+1

func action():
	pass #this type has no actions
