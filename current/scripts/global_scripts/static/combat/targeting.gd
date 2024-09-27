extends Node2D
class_name Targeting

static func simple_targeting(card: Card, type: String):
	if card.friendly:
		if card.shifted:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "opposing")
			else:
				return Callable(Targeting, type).call(card, "opposing")
		else:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "opposing")
			else:
				return Callable(Targeting, type).call(card, "opposing")
	else:
		if card.shifted:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "player")
			else:
				return Callable(Targeting, type).call(card, "player")
		else:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "player")
			else:
				return Callable(Targeting, type).call(card, "player")

static func simple_ally(card: Card, type: String):
	if card.friendly:
		if card.shifted:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "player")
			else:
				return Callable(Targeting, type).call(card, "player")
		else:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "player")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "player")
			else:
				return Callable(Targeting, type).call(card, "player")
	else:
		if card.shifted:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "opposing")
			else:
				return Callable(Targeting, type).call(card, "opposing")
		else:
			if card.pos == "front":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "center":
				return Callable(Targeting, type).call(card, "opposing")
			elif card.pos == "back":
				return Callable(Targeting, type).call(card, "opposing")
			else:
				return Callable(Targeting, type).call(card, "opposing")

static func even(_card: Card, party: String):
	match party:
		"player":
			Combat.target_add(Combat.player_party)
			return Combat.target_get()
		"opposing":
			Combat.target_add(Combat.opposing_party)
			return Combat.target_get()

static func front(_card: Card, party: String):
	match party:
		"player":
			if not Combat.player_front.is_empty():
				Combat.target_add(Combat.player_front)
			elif not Combat.player_center.is_empty():
				Combat.target_add(Combat.player_center)
			elif not Combat.player_back.is_empty():
				Combat.target_add(Combat.player_back)
			else: 
				Combat.target_add(Combat.player_party)
			return Combat.target_get()
		"opposing":
			if not Combat.opposing_front.is_empty():
				Combat.target_add(Combat.opposing_front)
			elif not Combat.opposing_center.is_empty():
				Combat.target_add(Combat.opposing_center)
			elif not Combat.opposing_back.is_empty():
				Combat.target_add(Combat.opposing_back)
			else: 
				Combat.target_add(Combat.opposing_party)
			return Combat.target_get()

static func same_pos(card: Card, party: String):
	match party:
		"player":
			if card.pos == "front" and not Combat.player_front.is_empty():
				Combat.target_add(Combat.player_front)
			elif card.pos == "center" and not Combat.player_center.is_empty():
				Combat.target_add(Combat.player_center)
			elif card.pos == "back" and not Combat.player_back.is_empty():
				Combat.target_add(Combat.player_back)
			else:
				Combat.target_add(Combat.player_party)
			return Combat.target_get()
		"opposing":
			if card.pos == "front" and not Combat.opposing_front.is_empty():
				Combat.target_add(Combat.opposing_front)
			elif card.pos == "center" and not Combat.opposing_center.is_empty():
				Combat.target_add(Combat.opposing_center)
			elif card.pos == "back" and not Combat.opposing_back.is_empty():
				Combat.target_add(Combat.opposing_back)
			else:
				Combat.target_add(Combat.opposing_party)
			return Combat.target_get()

static func specific_pos(party: String, pos: String):
	match party:
		"player":
			if pos == "front" and not Combat.player_front.is_empty():
				Combat.target_add(Combat.player_front)
			elif pos == "center" and not Combat.player_center.is_empty():
				Combat.target_add(Combat.player_center)
			elif pos == "back" and not Combat.player_back.is_empty():
				Combat.target_add(Combat.player_back)
			else:
				Combat.target_add(Combat.player_party)
			return Combat.target_get()
		"opposing":
			if pos == "front" and not Combat.opposing_front.is_empty():
				Combat.target_add(Combat.opposing_front)
			elif pos == "center" and not Combat.opposing_center.is_empty():
				Combat.target_add(Combat.opposing_center)
			elif pos == "back" and not Combat.opposing_back.is_empty():
				Combat.target_add(Combat.opposing_back)
			else:
				Combat.target_add(Combat.opposing_party)
			return Combat.target_get()
