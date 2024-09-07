extends StaticBody2D

var filled = false
var pos = "Default"
var pos_health = 100
var pos_attack = 10
var pos_defense = 0
var pos_speed = 0

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
		var summon = card_reg.enemy_list.duplicate().pick_random()
		var instance = summon.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		instance.new_slot = self
		instance.friendly = false
		cards.place_slot_opposing(instance)
		combat.add_initiative(instance)
		cards.fix_slot(self)

func action():
	pass #this type has no actions
