extends Node

#region Status 'dictionary'
func call_effect(effect: StatusEffect, stage: int) -> void:
	match effect.status:
		"poison":
			poison(effect, stage)
		"sleep":
			pass
#endregion

#region Statuses list
func poison(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			pass
		1:
			effect.card.direct_damage_magical(effect.potency)
			effect.turns = effect.turns-1
			if effect.turns <= 0:
				Status.cleanse(effect)
		2: 
			Combat.combat_board = Combat.combat_board + "Poison wore off\n"
#endregion
