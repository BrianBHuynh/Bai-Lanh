extends Node

func call_effect(effect: StatusEffect, stage: int) -> void:
	match effect.status:
		"poison":
			poison(effect, stage)
		"sleep":
			pass


func poison(effect: StatusEffect, stage: int) -> void:
	match stage:
		0:
			pass
		1:
			effect.card.damage_magical(effect.potency)
			effect.turns = effect.turns-1
			if effect.turns <= 0:
				poison(effect, 2)
		2: pass

func clear_poison(effect: StatusEffect) -> void:
	pass
