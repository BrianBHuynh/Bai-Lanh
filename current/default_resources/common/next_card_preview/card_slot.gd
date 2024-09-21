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

var max_cap = 1
var drawn = 0

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#initialize()

func _on_button_pressed() -> void:
	if is_instance_valid(Combat.initiative.front()) and drawn == 0:
		drawn = drawn + 1
		var instance = Combat.initiative.front().duplicate()
		instance.global_position = position
		get_parent().add_child(instance)
		if not Combat.initiative.front().friendly:
			instance.friendly = false
			instance.initialize()
		instance.get_child(1).disabled = true
		await get_tree().create_timer(5).timeout
		instance.queue_free()
		drawn = drawn-1

#func action():
	#if shift:
		#Cards.shift(cards_list.front())
#
#func place_action(_card):
	#pass
