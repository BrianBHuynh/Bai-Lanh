extends StaticBody2D

var filled = false
var pos = "Default"
var pos_health = 100
var pos_attack = 10
var pos_defense = 0
var pos_speed = 0

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
