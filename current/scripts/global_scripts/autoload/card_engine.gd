extends Node2D

#region Place slot
#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_player(card: Card) -> void:
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		card.slot.update_accepting()
		card.slot.fix_slot()
		card.remove_slot_effects()
	MoveLib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.normalize()
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		card.pos_remove()
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		card.pos_apply()
	card.apply_slot_effects()
	if not Combat.player_party.has(card):
		Combat.player_party.append(card)
		Combat.add_initiative(card)
	card.slot.fix_slot()
	card.current_position = card.slot.position
	card.slot.place_action(card)
	card.slot.update_accepting()

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_draw_pile(card: Card) -> void:
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		card.slot.fix_slot()
		card.remove_slot_effects()
	MoveLib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.normalize()
	card.slot.cards_list.append(card)
	card.slot.fix_slot()
	card.current_position = card.slot.position

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_opposing(card: Card) -> void:
	if is_instance_valid(card.slot):
		card.slot.cards.erase(card)
		card.slot.fix_slot()
		card.remove_slot_effects()
	MoveLib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.normalize()
	card.slot.normalize()
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		card.pos_remove()
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		card.pos_apply()
	card.apply_slot_effects()
	Combat.add_initiative(card)
	if not Combat.opposing_party.has(card):
		Combat.opposing_party.append(card)
	card.slot.fix_slot()
	card.current_position = card.slot.position
#endregion

#region Add/Remove Slot
#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func add_slot(card: Card, slot: Node2D) -> void:
	if slot.is_in_group('slot') and slot.accepting:
		slot.highlight()
		card.new_slot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func add_card(card: Card, new_card: Area2D) -> void:
	if is_instance_valid(new_card.slot) and new_card.slot.accepting and not new_card.held and new_card.friendly:
		card.new_slot = new_card.slot
		new_card.highlight()
		new_card.slot.highlight()

#Decriments the slotted variable, then returns the slot back to it's default color
func remove_slot(_card: Card, slot) -> void:
	slot.normalize()

#Decriments the slotted variable, then returns the card back to it's default color
func remove_card(card: Card, _new_card) -> void:
	if not card.held and card.friendly and not card.inspected:
		card.normalize()
		card.slot.normalize()
#endregion

#region Misc mechanics
#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickup(card: Card) -> void:
	card.offset = get_global_mouse_position() - card.global_position #dubious
	GlobalVars.dragging_card = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);
#endregion
