extends Node2D

var stacking_distance = 50

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_player(card: Card):
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		fix_slot(card.slot)
		card.remove_slot_effects()
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.ALICE_BLUE, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		card.pos_remove()
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		card.pos_apply()
	card.apply_slot_effects()
	if not combat.player_party.has(card):
		combat.player_party.append(card)
		combat.add_initiative(card)
	fix_slot(card.slot)
	card.current_position = card.slot.position
	card.slot.place_action(card)

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_draw_pile(card: Card):
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		fix_slot(card.slot)
		card.remove_slot_effects()
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.ALICE_BLUE, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		card.pos_remove()
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		card.pos_apply()
	card.apply_slot_effects()
	fix_slot(card.slot)
	card.current_position = card.slot.position

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_opposing(card: Card):
	if is_instance_valid(card.slot):
		card.slot.cards.erase(card)
		fix_slot(card.slot)
		card.remove_slot_effects()
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.default_color = Color(Color.PALE_VIOLET_RED)
	card.modulate = Color(Color.PALE_VIOLET_RED)
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.RED, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		card.pos_remove()
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		card.pos_apply()
	card.apply_slot_effects()
	if not combat.opposing_party.has(card):
		combat.opposing_party.append(card)
	fix_slot(card.slot)
	card.current_position = card.slot.position

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func add_slot(card: Card, slot: Node2D):
	if slot.is_in_group('slot') and slot.accepting:
		slot.modulate = Color(Color.GOLD, 1)
		slot.scale = Vector2(1.1,1.1)
		card.new_slot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func add_card(card: Card, new_card: Area2D):
	if is_instance_valid(new_card.slot) and new_card.slot.accepting:
		card.new_slot = new_card.slot
		new_card.modulate = Color(Color.GOLD, 1)
		new_card.scale = Vector2(1.1,1.1)
		new_card.slot.modulate = Color(Color.GOLD, 1)
		new_card.slot.scale = Vector2(1.1,1.1)

#Decriments the slotted variable, then returns the slot back to it's default color
func remove_slot(card: Card, slot):
	if card.new_slot == slot:
		card.new_slot = null
	slot.modulate = slot.default_color
	slot.scale = slot.default_size

#Decriments the slotted variable, then returns the card back to it's default color
func remove_card(card: Card, slot):
	if card.new_slot == slot:
		card.new_slot = null

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickup(card: Card):
	card.offset = get_global_mouse_position() - card.global_position #dubious
	global_vars.dragging_card = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);

func fix_slot(slot: Node2D):
	var temp = 0
	for elem in slot.cards_list:
		elem.move_to_front()
		move_lib.move(elem, slot.global_position + Vector2(0,stacking_distance)*temp)
		temp = temp + 1
