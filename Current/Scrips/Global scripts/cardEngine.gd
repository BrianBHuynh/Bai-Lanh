extends Node2D

var stackingDistance = 50
#Takes care of card movement each turn
func move(card):
	if card.draggable: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable
		if Input.is_action_just_pressed("leftClick"):
				globalVars.curCard.append(card)
				pickup(card)
				await get_tree().create_timer(0.02).timeout
				if globalVars.curCard.size() > 1:
					checkFront()
				if globalVars.curCard.front() == card:
					card.move_to_front()
				else:
					card.draggable = false
		if Input.is_action_pressed("leftClick"):
				hold(card)
		elif Input.is_action_just_released("leftClick"):
			globalVars.curCard.clear()
			card.modulate = card.defaultColor
			globalVars.draggingCard = false
			var tween = get_tree().create_tween()
			if card.slotted > 0 && is_instance_valid(card.newSlot) && not card.newSlot.filled:
				placeSlot(card, tween)
			elif card.slotted > 0 && is_instance_valid(card.newCard) && is_instance_valid(card.newCard.bottomCard.curSlot):
				placeCard(card, tween)
			else:
				reject(card, tween)

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func addSlot(card, slot: Node2D):
	card.slotted = card.slotted + 1
	if not slot.filled:
		slot.modulate = Color(Color.GOLD, 1)
		slot.scale = Vector2(1.1,1.1)
		card.newSlot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func addCard(card, newCard: Node2D):
	card.slotted = card.slotted + 1
	if not is_instance_valid(newCard.cardAbove):
		newCard.modulate = Color(Color.GOLD, 1)
		newCard.scale = Vector2(1.1,1.1)
		card.newCard = newCard

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot(card, slot: Node2D):
	if is_instance_valid(slot):
		slot.modulate = Color(Color.WHITE, 1)
		slot.scale = Vector2(1, 1)
	card.slotted = card.slotted - 1
	if card.slotted == 0:
		card.scale = card.defaultSize
		card.modulate = card.defaultColor

#Decriments the slotted variable, then returns the card back to it's default color
func removeCard(card, newCard: Node2D):
	if is_instance_valid(newCard):
		newCard.modulate = Color(Color.WHITE, 1)
		newCard.scale = Vector2(1, 1)
	card.slotted = card.slotted - 1
	if card.slotted == 0:
		card.scale = card.defaultSize
		card.modulate = card.defaultColor

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

#Updates card location
func hold(card):
	card.global_position = get_global_mouse_position() - card.offset

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeSlot(card, tween: Tween):
	tween.tween_property(card,"position",card.newSlot.position,0.2).set_ease(Tween.EASE_OUT)
	if is_instance_valid(card.curSlot):
		card.curSlot.filled = false
	card.curSlot = card.newSlot
	card.curSlot.filled = true
	card.curSlot.scale = Vector2(1,1)
	card.curSlot.modulate = Color(Color.ALICE_BLUE, .4)
	if not combat.playerParty.has(card):
		combat.playerParty.append(card)

#Moves card location to the card's location translated upwards slightly, places card into the lowest's card's register, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeCard(card, tween: Tween):
	tween.tween_property(card,"position",card.newCard.position + Vector2(0, stackingDistance),0.2).set_ease(Tween.EASE_OUT)
	if is_instance_valid(card.curSlot):
		card.curSlot.filled = false
	if is_instance_valid(card.cardBelow):
		card.cardBelow.cardAbove = null
	card.cardBelow = card.newCard
	card.bottomCard = card.cardBelow.bottomCard
	card.cardBelow.cardAbove = card
	card.cardBelow.scale = card.cardBelow.defaultSize
	card.cardBelow.modulate = card.cardBelow.defaultColor

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

func checkFront():
	globalVars.curCard.sort_custom(frontComparator)

func frontComparator(a, b):
	if a.get_index() > b.get_index():
		return true
	return false

func recursiveMoveUp(card):
	if is_instance_valid(card.cardAbove):
		card.cardAbove.cardBelow = card.cardBelow
		card.cardAbove.position - Vector2(0, stackingDistance)
		recursiveMoveUp(card.cardAbove)
		
