extends Node2D

#Takes care of card movement each turn
func move(card):
	if card.draggable: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable
		if Input.is_action_just_pressed("leftClick"):
			pickup(card)
		if Input.is_action_pressed("leftClick"):
			hold(card)
		elif Input.is_action_just_released("leftClick"):
			card.modulate = card.defaultColor;
			globalVars.draggingCard = false
			var tween = get_tree().create_tween()
			if card.slotted > 0 && is_instance_valid(card.newSlot) && not card.newSlot.filled:
				place(card, tween)
			else:
				reject(card, tween)

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func addSlot(card, slot: Node2D):
	card.slotted = card.slotted + 1
	slot.modulate = Color(Color.SKY_BLUE, 2)
	slot.scale = Vector2(1.1,1.1)
	card.newSlot = slot

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot(card):
	card.slotted = card.slotted - 1
	if card.slotted == 0:
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.ALICE_BLUE, 1)

#Makes card draggable and shows that it is to player by changing color and size
func mouseOver(card):
	if not globalVars.draggingCard:
		card.draggable = true
		card.scale = Vector2(1.1, 1.1)
		card.modulate = Color(Color.ALICE_BLUE, 1)

#Returns card back to normal
func mouseOff(card):
	if not globalVars.draggingCard:
		card.draggable = false
		card.modulate = card.defaultColor
		card.scale = card.defaultSize

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickup(card):
	card.offset = get_global_mouse_position() - card.global_position
	card.initialPos = card.global_position
	globalVars.draggingCard = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);
	card.move_to_front()

#Updates card location
func hold(card):
	card.global_position = get_global_mouse_position() - card.offset

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func place(card, tween: Tween):
	tween.tween_property(card,"position",card.newSlot.position,0.2).set_ease(Tween.EASE_OUT)
	if is_instance_valid(card.curSlot):
		card.curSlot.filled = false
	card.curSlot = card.newSlot
	card.curSlot.filled = true
	if not combat.playerParty.has(card):
		combat.playerParty.append(card)

#returns card back to old position when picking up
func reject(card, tween: Tween):
	tween.tween_property(card,"global_position",card.initialPos,0.2).set_ease(Tween.EASE_OUT)

#Applies slot stats and effects
func slotApply(card):
	card.health = card.health + card.curSlot.slotHealth
	card.attack = card.attack + card.curSlot.slotAttack
	card.defense = card.defense + card.curSlot.slotDefense
	card.speed = card.speed + card.curSlot.slotSpeed
	card.curSlot.activate()

func posApply(card):
	if card.prefPos.has(card.curSlot.pos):
		card.health = card.health + card.posHealth
		card.attack = card.attack + card.posAttack
		card.defense = card.defense + card.posDefense
		card.speed = card.speed + card.posSpeed
		card.posEffect(card.curSlot.pos)
