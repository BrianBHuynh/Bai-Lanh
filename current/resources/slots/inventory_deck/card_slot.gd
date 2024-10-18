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

@export var slot_card_max = 50

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
	accepting = true
	card_max = slot_card_max
	initialize()

func _on_button_pressed() -> void:
	var inventory_save:Array = Saves.load_file("inventory_save")
	for card_dat: Dictionary in inventory_save:
		var card = CardReg.card_from_dat(card_dat)
		get_parent().add_child(card)
		card.position = position
		card.new_slot = self
		Cards.place_slot(card)
		fix_slot()

#func action():
	#if shift:
		#Cards.shift(cards_list.front())

func place_action(_card):
	fix_slot()
	var temp_cards_list: Array = []
	for card:Card in cards_list:
		temp_cards_list.append(card.serialize())
	Saves.save_file(temp_cards_list, "inventory_save")
