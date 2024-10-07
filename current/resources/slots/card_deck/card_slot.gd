extends Slot

@export var slot_pos = "Default"
@export var slot_health: float = 0.0
@export var slot_phys_attack: float = 0
@export var slot_mag_attack: float = 0
@export var slot_phys_defense: float = 0
@export var slot_mag_defense: float = 0
@export var slot_speed: int = 0
@export var slot_tags: Array = []
@export var slot_shift:bool = false

@export var slot_card_max = 1

var max_cap = 10
var drawn = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos = slot_pos
	health = slot_health
	phys_attack = slot_phys_attack
	mag_attack = slot_mag_attack
	slot_phys_defense = phys_defense
	slot_mag_defense = mag_defense
	speed = slot_speed
	tags.append_array(slot_tags)
	shift = slot_shift
	card_max = slot_card_max
	accepting = false
	initialize()

func _on_button_pressed() -> void:
	if drawn < max_cap:
		var summon: Card = load(CardReg.ally_list.pick_random()).instantiate()
		summon.position = position
		get_parent().add_child(summon)
		summon.new_slot = self
		Cards.place_slot(summon)
		fix_slot()
		drawn = drawn+1

#func action():
	#if shift:
		#Cards.shift(cards_list.front())
#
#func place_action(_card):
	#pass
