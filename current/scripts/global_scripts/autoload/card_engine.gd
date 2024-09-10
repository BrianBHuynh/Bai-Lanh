extends Node2D

var stacking_distance = 50

func hold_card(card):
	move_lib.move_fast(card, get_global_mouse_position() - card.offset)
	card.move_to_front()

func release_card(card):
	if is_instance_valid(card.new_slot) and card.new_slot.accepting:
		place_slot_player(card)
		fix_slot(card.slot)
	else:
		reject(card)
		card.new_slot = null

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_player(card):
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		fix_slot(card.slot)
		remove_slot_effects(card, card.slot)
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.ALICE_BLUE, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		pos_remove(card)
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		pos_apply(card)
	apply_slot_effects(card, card.slot)
	if not combat.player_party.has(card):
		combat.player_party.append(card)
		combat.add_initiative(card)
	fix_slot(card.slot)
	card.current_position = card.slot.position
	card.slot.place_action(card)

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_draw_pile(card):
	if is_instance_valid(card.slot):
		card.slot.cards_list.erase(card)
		fix_slot(card.slot)
		remove_slot_effects(card, card.slot)
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.ALICE_BLUE, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		pos_remove(card)
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		pos_apply(card)
	apply_slot_effects(card, card.slot)
	fix_slot(card.slot)
	card.current_position = card.slot.position

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place_slot_opposing(card):
	if is_instance_valid(card.slot):
		card.slot.cards.erase(card)
		fix_slot(card.slot)
		remove_slot_effects(card, card.slot)
	move_lib.move(card, card.new_slot.position)
	card.slot = card.new_slot
	card.new_slot = null
	card.default_color = Color(Color.PALE_VIOLET_RED)
	card.modulate = Color(Color.PALE_VIOLET_RED)
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.RED, .4)
	card.slot.cards_list.append(card)
	if card.pref_pos.has(card.pos):
		pos_remove(card)
	card.pos = card.slot.pos
	if card.pref_pos.has(card.pos):
		pos_apply(card)
	apply_slot_effects(card, card.slot)
	if not combat.opposing_party.has(card):
		combat.opposing_party.append(card)
	fix_slot(card.slot)
	card.current_position = card.slot.position

#returns card back to old position when picking up
func reject(card):
	if is_instance_valid(card.slot):
		fix_slot(card.slot)
	else:
		move_lib.move(card, card.current_position)

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func add_slot(card, slot: Node2D):
	if slot.is_in_group('slot') and slot.accepting:
		slot.modulate = Color(Color.GOLD, 1)
		slot.scale = Vector2(1.1,1.1)
		card.new_slot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func add_card(card, new_card: Area2D):
	if is_instance_valid(new_card.slot) and new_card.slot.accepting:
		card.new_slot = new_card.slot
		new_card.modulate = Color(Color.GOLD, 1)
		new_card.scale = Vector2(1.1,1.1)
		new_card.slot.modulate = Color(Color.GOLD, 1)
		new_card.slot.scale = Vector2(1.1,1.1)

#Decriments the slotted variable, then returns the slot back to it's default color
func remove_slot(card, slot):
	if card.new_slot == slot:
		card.new_slot = null
	slot.modulate = slot.default_color
	slot.scale = slot.default_size

#Decriments the slotted variable, then returns the card back to it's default color
func remove_card(card, slot):
	if card.new_slot == slot:
		card.new_slot = null

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickup(card):
	card.offset = get_global_mouse_position() - card.global_position #dubious
	global_vars.dragging_card = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);

func check_front():
	global_vars.cur_card.sort_custom(front_comparator)

func front_comparator(a, b):
	if a.get_index() > b.get_index():
		return true
	return false

func fix_slot(slot: Node2D):
	var temp = 0
	for elem in slot.cards_list:
		elem.move_to_front()
		move_lib.move(elem, slot.global_position + Vector2(0,stacking_distance)*temp)
		temp = temp + 1

func shift(card):
	if not card.shifted:
		card.shifted = true
		card.health = card.health + card.shifted_health
		card.phys_attack = card.phys_attack + card.shifted_phys_attack 
		card.mag_attack = card.mag_attack + card.shifted_mag_attack 
		card.phys_defense = card.phys_defense + card.shifted_phys_defense 
		card.mag_defense = card.mag_defense + card.shifted_mag_defense 
		card.speed = card.speed + card.shifted_speed
		card.tags.append(card.shifted_tags)
	else:
		card.shifted = false
		card.health = card.health - card.shifted_health
		card.phys_attack = card.phys_attack - card.shifted_phys_attack 
		card.mag_attack = card.mag_attack - card.shifted_mag_attack 
		card.phys_defense = card.phys_defense - card.shifted_phys_defense 
		card.mag_defense = card.mag_defense - card.shifted_mag_defense 
		card.speed = card.speed - card.shifted_speed
		for i in card.shifted_tags.size():
			card.tags.erase(card.shifted_tags[i])
	combat.update_initiative(self)


func apply_slot_effects(card, slot):
	card.health = card.health + slot.health
	card.phys_attack = card.phys_attack + slot.phys_attack 
	card.mag_attack = card.mag_attack + slot.mag_attack 
	card.phys_defense = card.phys_defense + slot.phys_defense 
	card.mag_defense = card.mag_defense + slot.mag_defense 
	card.speed = card.speed + slot.speed
	card.tags.append_array(slot.tags)
	combat.update_initiative(self)

func remove_slot_effects(card, slot):
	card.health = card.health - slot.health
	card.phys_attack = card.phys_attack - slot.phys_attack
	card.mag_attack = card.mag_attack - slot.mag_attack 
	card.phys_defense = card.phys_defense - slot.phys_defense 
	card.mag_defense = card.mag_defense - slot.mag_defense 
	card.speed = card.speed - slot.speed
	for i in slot.tags.size():
		card.tags.erase(slot.tags[i])
	combat.update_initiative(self)

func pos_apply(card):
	card.health = card.health + card.pos_health
	card.phys_attack = card.phys_attack + card.pos_phys_attack 
	card.mag_attack = card.mag_attack + card.pos_mag_attack 
	card.phys_defense = card.phys_defense + card.pos_phys_defense 
	card.mag_defense = card.mag_defense + card.pos_mag_defense 
	card.speed = card.speed + card.pos_speed
	card.tags.append(card.pos_tags)
	combat.update_initiative(self)

func pos_remove(card):
	card.health = card.health - card.pos_health
	card.phys_attack = card.phys_attack - card.pos_phys_attack 
	card.mag_attack = card.mag_attack - card.pos_mag_attack 
	card.phys_defense = card.phys_defense - card.pos_phys_defense 
	card.mag_defense = card.mag_defense - card.pos_mag_defense 
	card.speed = card.speed - card.pos_speed
	for i in card.pos_tags.size():
		card.tags.erase(card.pos_tags[i])
	combat.update_initiative(card)
