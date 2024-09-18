extends Node

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
			Combat.update(effect.card)
		1:
			effect.duration_pass()
		2: 
			effect.card.speed = effect.card.speed + effect.potency
			Combat.combat_board = Combat.combat_board + "is no longer stunned!\n"
			Combat.update(effect.card)

func phys_defense_up(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			effect.card.phys_defense = effect.card.phys_defense + effect.potency
		1:
			effect.duration_pass()
		2:
			effect.card.phys_defense = effect.card.phys_defense - effect.potency

func phys_attack_up(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			effect.card.phys_attack = effect.card.phys_attack + effect.potency
		1:
			effect.duration_pass()
		2:
			effect.card.phys_attack = effect.card.phys_attack + effect.potency
#endregion
