extends Node2D

var latest = "none"
var stackingDistance = 50
#Takes care of card movement each turn
func moveScript(card):
	if card.draggable and not moveLib.animRunning: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable, does not allow inputs while animations are playing
		if Input.is_action_just_pressed("leftClick"):
			leftClickAction(card)
		elif Input.is_action_pressed("leftClick"):
			leftHoldAction(card)
		elif Input.is_action_just_released("leftClick"):
			leftReleaseAction(card)

func leftClickAction(card):
	globalVars.curCard.append(card)
	pickup(card)
	await get_tree().create_timer(0.02).timeout
	if globalVars.curCard.size() > 1:
		checkFront()
	if globalVars.curCard.front() == card:
		card.move_to_front()
	else:
		card.draggable = false

func leftHoldAction(card):
	card.global_position = get_global_mouse_position() - card.offset

func leftReleaseAction(card):
	globalVars.curCard.clear()
	card.modulate = card.defaultColor
	globalVars.draggingCard = false
	if card.slotted > 0 && is_instance_valid(card.newSlot) and not card.newSlot.filled and card.newSlot != card.curSlot and latest == "slot":
		placeSlot(card)
	elif card.carded > 0 && is_instance_valid(card.newCard) and is_instance_valid(card.newCard.bottomCard.curSlot) and not is_instance_valid(card.newCard.cardAbove) and latest == "card":
		placeCard(card)
	else:
		reject(card)

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeSlot(card):
	if is_instance_valid(card.curSlot) and not is_instance_valid(card.cardAbove):
		card.curSlot.filled = false
	moveUp(card)
	moveLib.move(card, card.newSlot.position)
	card.initialPos = card.newSlot.position
	card.curSlot = card.newSlot
	card.curSlot.filled = true
	card.curSlot.scale = Vector2(1,1)
	card.curSlot.modulate = Color(Color.ALICE_BLUE, .4)
	if not combat.playerParty.has(card):
		combat.playerParty.append(card)
	card.cardAbove = null
	card.cardBelow = null
	card.bottomCard = card

#Moves card location to the card's location translated upwards slightly, places card into the lowest's card's register, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeCard(card):
	if is_instance_valid(card.curSlot) and not is_instance_valid(card.cardAbove):
		card.curSlot.filled = false
	moveUp(card)
	moveLib.move(card, card.newCard.position + Vector2(0, stackingDistance))
	card.initialPos = (card.newCard.position + Vector2(0, stackingDistance))
	card.cardBelow = card.newCard
	card.bottomCard = card.cardBelow.bottomCard
	card.cardBelow.cardAbove = card
	card.cardBelow.scale = card.cardBelow.defaultSize
	card.cardBelow.modulate = card.cardBelow.defaultColor
	card.cardAbove = null

#returns card back to old position when picking up
func reject(card):
	moveLib.move(card, card.initialPos)

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func addSlot(card, slot: Node2D):
	if slot.is_in_group('slot'):
		card.slotted = card.slotted + 1
		if not slot.filled:
			latest = "slot"
			slot.modulate = Color(Color.GOLD, 1)
			slot.scale = Vector2(1.1,1.1)
			card.newSlot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func addCard(card, newCard: Node2D):
	if newCard.is_in_group('stackable'):
		card.carded = card.carded + 1
		if not is_instance_valid(newCard.cardAbove):
			latest = "card"
			newCard.modulate = Color(Color.GOLD, 1)
			newCard.scale = Vector2(1.1,1.1)
			card.newCard = newCard

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot(card, slot: Node2D):
	if slot.is_in_group('slot'):
		if is_instance_valid(slot):
			slot.modulate = Color(Color.WHITE, 1)
			slot.scale = Vector2(1, 1)
		card.slotted = card.slotted - 1
		if card.slotted == 0:
			card.scale = card.defaultSize
			card.modulate = card.defaultColor

#Decriments the slotted variable, then returns the card back to it's default color
func removeCard(card, newCard: Node2D):
	if newCard.is_in_group('stackable'):
		if is_instance_valid(newCard):
			newCard.modulate = Color(Color.WHITE, 1)
			newCard.scale = Vector2(1, 1)
		card.carded = card.carded - 1
		if card.carded == 0:
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
	globalVars.draggingCard = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);

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

#Moves cards up if a middle or bottom card is removed, if bottom is removed changes the bottom of the stack to cardAbove
func moveUp(card):
	if card.bottomCard == card and is_instance_valid(card.cardAbove):
		card.cardAbove.bottomCard = card.cardAbove
		card.cardAbove.cardBelow = null
		card.cardAbove.curSlot = card.curSlot
		changeBotLoop(card.cardAbove)
	if is_instance_valid(card.cardBelow):
		card.cardBelow.cardAbove = card.cardAbove
	if is_instance_valid(card.cardAbove) and is_instance_valid(card.cardBelow):
		card.cardAbove.cardBelow = card.cardBelow
	if is_instance_valid(card.cardAbove):
		var temp = card.cardAbove
		card.cardAbove = null
		moveLib.move(temp, temp.position - Vector2(0, stackingDistance))
		moveUpLoop(temp)
	elif is_instance_valid(card.curSlot):
		card.curSlot.filled = false

func moveUpLoop(card):
	if is_instance_valid(card.cardAbove):
		moveLib.move(card.cardAbove, card.cardAbove.position - Vector2(0, stackingDistance))
		moveUpLoop(card.cardAbove)

func changeBotLoop(card):
	if is_instance_valid(card.cardAbove):
		card.cardAbove.bottomCard = card.bottomCard
		changeBotLoop(card.cardAbove) 
