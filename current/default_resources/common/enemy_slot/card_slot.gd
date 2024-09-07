extends StaticBody2D

var filled = false
var pos = "Default"
var posHealth = 100
var posAttack = 10
var posDefense = 0
var posSpeed = 0

var cardsList: Array = []
var accepting: bool = false

var maxCap = 1

var defaultColor = Color(Color.RED, .7)
var defaultSize = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.slots.append(self)
	modulate = Color(Color.RED, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	if cardsList.size() < maxCap:
		var summon = card_reg.enemy_list.duplicate().pick_random()
		var instance = summon.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		instance.newSlot = self
		cards.placeSlotOpposing(instance)
		combat.addInitiative(instance)
		cards.fixSlot(self)
