extends Slot

@export var slot_pos: String = "Default"
@export var slot_health: float = 0.0
@export var slot_phys_attack: float = 0
@export var slot_mag_attack: float = 0
@export var slot_phys_defense: float = 0
@export var slot_mag_defense: float = 0
@export var slot_speed: int = 0
@export var slot_tags: Array = []
@export var slot_shift:bool = false

@export var slot_card_max: int = 50

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
	var inventory_save: Variant = Saves.load_file("inventory_save")
	if typeof(inventory_save) == TYPE_ARRAY:
		for card_dat: Dictionary in inventory_save:
			var card: Card = CardReg.get_card(card_dat.get("script_link", "res://current/resources/templates/template_card/template.gd"))
			card.position = position
			get_parent().add_child(card)
			card.new_slot = self
			Cards.place_slot(card)
			fix_slot()
			card.load_data(card_dat)

#func action():
	#if shift:
		#Cards.shift(cards_list.front())

func place_action(card: Card) -> void:
	fix_slot()
	var temp_cards_list: Array = []
	for cards:Card in cards_list:
		temp_cards_list.append(cards.serialize())
	Saves.save_file(temp_cards_list, "inventory_save")
	Combat.remove_combat(card)
