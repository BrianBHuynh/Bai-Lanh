extends Node

#region Status 'dictionary'
func call_effect(effect: StatusEffect, stage: int) -> void:
	match effect.status:
		"poison":
			poison(effect, stage)
		"slow":
			slow(effect, stage)
#endregion

#region Statuses list
func poison(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			pass
		1:
			effect.card.direct_damage_magical(effect.potency)
			effect.duration_pass()
		2: 
			Combat.combat_board = Combat.combat_board + "Poison wore off\n"

#for the slow effect, depending on the potency of the effect, as well as the condition, different effects can be made
#if potency is equal to card.speed, it is a perfect stun, depending on the condition it can wear off after x turns, or after the card goes through x moves
#this can be used as a stun, a duration slow, a duration stun, or more
func slow(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			effect.card.speed = effect.card.speed - effect.potency
			Combat.update_initiative(effect.card)
		1:
			effect.duration_pass()
		2: 
			effect.card.speed = effect.card.speed + effect.potency
			Combat.combat_board = Combat.combat_board + "is no longer stunned!\n"
			Combat.update_initiative(effect.card)
#endregion
