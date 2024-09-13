extends Node

var status_effects: Array[StatusEffect] = []

func call_status(effect: StatusEffect, stage: int) -> void:
	if is_instance_valid(effect.card):
		StatusLib.call_effect(effect, stage)
	else:
		Status.status_effects.erase(effect)
		effect.queue_free()

func tick() -> void:
	for status in status_effects:
		call_status(status, 1)

func apply(effect: StatusEffect) -> void:
	match effect.activation:
		"instant":
			effect.card.perma_statuses.append(effect)
			call_status(effect, 0)
		"on_turn":
			effect.card.statuses.append(effect)
			call_status(effect, 0)
		"every_turn":
			status_effects.append(effect)
			call_status(effect, 0)

func cleanse_all(card: Card) -> void:
	if is_instance_valid(card):
		for status in card.perma_statuses:
			call_status(status, 2)
			status.queue_free()
		card.perma_statuses.clear()
		for status in card.statuses:
			call_status(status, 2)
			status.queue_free()
		card.statuses.clear()
	for status in status_effects:
		if status.card == card:
			call_status(status, 2)
			status_effects.erase(status)

func cleanse_once(card: Card) -> void:
	var cleared = false
	if is_instance_valid(card):
		for status in card.perma_statuses:
			call_status(status, 2)
			status.queue_free()
			cleared = true
			break;
		if not cleared:
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

func cleanse(status: StatusEffect):
	call_status(status, 2)
	if status.card.perma_statuses.has(status):
		status.card.perma_statuses.erase(status)
	elif status.card.statuses.has(status):
		status.card.statuses.erase(status)
	elif status_effects.has(status):
		status_effects.erase(status)
