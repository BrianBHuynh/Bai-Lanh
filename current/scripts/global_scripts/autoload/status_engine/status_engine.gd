extends Node

var status_effects: Array[StatusEffect] = []

func call_status(effect: StatusEffect, stage: int) -> void:
	if is_instance_valid(effect.card):
		StatusLib.call_effect(effect, 1)
	else:
		Status.status_effects.erase(effect)
		effect.queue_free()

func tick() -> void:
	for status in status_effects:
		call_status(status, 1)

func apply(effect: StatusEffect) -> void:
	match effect.activation:
		"instant":
			effect.card.statuses.append(effect)
			call_status(effect, 0)
		"on_turn":
			effect.card.statuses.append(effect)
			call_status(effect, 0)
		"every_turn":
			status_effects.append(effect)
			call_status(effect, 0)

func cleanse_all(card: Card) -> void:
	if is_instance_valid(card):
		for status in card.statuses:
			call_status(status, 2)
			status.queue_free()
		card.statuses.clear()
	for status in status_effects:
		if status.card == card:
			call_status(status, 2)
			status_effects.erase(status)

func cleanse(card: Card) -> void:
	var cleared = false
	if is_instance_valid(card):
		for status in card.statuses:
			call_status(status, 2)
			status.queue_free()
			cleared = true
			break;
	if not cleared:
		for status in status_effects:
			if status.card == card:
				call_status(status, 2)
				status_effects.erase(status)
