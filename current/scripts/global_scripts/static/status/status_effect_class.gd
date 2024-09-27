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
func _init(init_status: String, init_turns: int, init_activation: String, init_potency: int, init_card: Card) -> void:
	status = init_status
	turns = init_turns
	activation = init_activation
	potency = init_potency
	card = init_card
#endregion

func duration_pass() -> void:
	turns = turns-1
	if turns <= 0:
		Status.cleanse(self)
