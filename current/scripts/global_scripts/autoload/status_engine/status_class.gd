extends Node
class_name status_effect

var status: String
var turns: int
var activation: String
var potency: int
var card

func _init(status, turns, activation, potency, card) -> void:
	self.status = status
	self.turns = turns
	self.activation = activation
	self.potency = potency
	self.card = card
