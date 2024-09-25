extends Slot

@export var slot_pos = "Default"
@export var slot_health: float = 0.0
@export var slot_phys_attack: int = 0
@export var slot_mag_attack: int = 0
@export var slot_phys_defense: int = 0
@export var slot_mag_defense: int = 0
@export var slot_speed: int = 0
@export var slot_tags: Array = []
@export var slot_shift:bool = false

@export var slot_card_max = 1

var summoned: bool = false

## Called when the node enters the scene tree for the first time.
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
	initialize()
	default_color = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not summoned:
		var summon: Card = load(CardReg.enemy_list.pick_random()).instantiate()
		summon.position = position
		get_parent().add_child(summon)
		summon.new_slot = self
		summon.friendly = false
		Cards.place_slot_combat(summon)
		summon.initialize()
		fix_slot()
		summoned = true

#func action():
	#if shift:
		#Cards.shift(cards_list.front())
#
#func place_action(_card):
	#pass
