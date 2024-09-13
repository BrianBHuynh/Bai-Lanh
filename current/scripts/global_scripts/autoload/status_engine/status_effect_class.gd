extends Node
class_name StatusEffect

#region Variables
var status: String
var turns: int
var activation: String
var potency: int
var card: Card
#endregion

#region Initialization
func _init(init_status, init_turns, init_activation, init_potency, init_card) -> void:
	status = init_status
	turns = init_turns
	activation = init_activation
	potency = init_potency
	card = init_card
#endregion
