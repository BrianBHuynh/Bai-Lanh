extends Node2D

var latest = "none"
var stackingDistance = 50
#Takes care of card movement each turn
func moveScript(card):
	if card.draggable: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable, does not allow inputs while animations are playing
		if Input.is_action_just_pressed("leftClick"):
			leftClickAction(card)
		elif Input.is_action_pressed("leftClick"):
			if globalVars.draggingCard == true:
				leftHoldAction(card)
		elif Input.is_action_just_released("leftClick"):
			leftReleaseAction(card)
			globalVars.draggingCard = false

func leftClickAction(card):
	globalVars.curCard.append(card)
	pickup(card)
	await get_tree().create_timer(0.001).timeout
	if globalVars.curCard.size() > 1:
		checkFront()
	if globalVars.curCard.front() == card:
		card.move_to_front()
	else:
		card.draggable = false
	leftHoldAction(card)
	if is_instance_valid(card.slot):
		fixSlot(card.slot)

func leftHoldAction(card):
	moveLib.moveFast(card, get_global_mouse_position() - card.offset)

func leftReleaseAction(card):
	globalVars.curCard.clear()
	card.modulate = card.defaultColor
	globalVars.draggingCard = false
	if is_instance_valid(card.newSlot) and card.newSlot.accepting:
		placeSlot(card)
		fixSlot(card.slot)
	else:
		reject(card)
		card.newSlot = null

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeSlot(card):
	if is_instance_valid(card.slot):
		card.slot.cards.erase(card)
		fixSlot(card.slot)
	moveLib.move(card, card.newSlot.position)
	card.slot = card.newSlot
	card.newSlot = null
	card.slot.scale = Vector2(1,1)
	card.slot.modulate = Color(Color.ALICE_BLUE, .4)
	card.slot.cards.append(card)
	if not combat.playerParty.has(card):
		combat.playerParty.append(card)
	fixSlot(card.slot)
	card.curPosition = card.slot.position

#returns card back to old position when picking up
func reject(card):
	if is_instance_valid(card.slot):
		fixSlot(card.slot)
	else:
		moveLib.move(card, card.initialPos)

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func addSlot(card, slot: Node2D):
	if slot.is_in_group('slot') and slot.accepting:
		slot.modulate = Color(Color.GOLD, 1)
		slot.scale = Vector2(1.1,1.1)
		card.newSlot = slot

#Places the location of the cardBelow to the latest card it passes over if the card is a top card
func addCard(card, newCard: Area2D):
	if is_instance_valid(newCard.slot) and newCard.slot.accepting:
		card.newSlot = newCard.slot
		newCard.modulate = Color(Color.GOLD, 1)
		newCard.scale = Vector2(1.1,1.1)
		newCard.slot.modulate = Color(Color.GOLD, 1)
		newCard.slot.scale = Vector2(1.1,1.1)

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot(card, slot):
	if card.newSlot == slot:
		card.newSlot = null

#Decriments the slotted variable, then returns the card back to it's default color
func removeCard(card, slot):
	if card.newSlot == slot:
		card.newSlot = null

#Makes card draggable and shows that it is to player by changing color and size
func mouseOver(card):
	if is_instance_valid(card.slot):
		fixSlot(card.slot)
	if not globalVars.draggingCard:
		card.draggable = true
		card.scale = Vector2(1.1, 1.1)
		card.modulate = Color(Color.ALICE_BLUE, 1)

#Returns card back to normal
func mouseOff(card):
	if is_instance_valid(card.slot):
		fixSlot(card.slot)
	if not globalVars.draggingCard:
		card.draggable = false
		card.modulate = card.defaultColor
		card.scale = card.defaultSize

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickup(card):
	card.offset = get_global_mouse_position() - card.global_position #dubious
	globalVars.draggingCard = true
	card.modulate = Color(Color.LIGHT_GOLDENROD, 1.5);

func checkFront():
	globalVars.curCard.sort_custom(frontComparator)

func frontComparator(a, b):
	if a.get_index() > b.get_index():
		return true
	return false

func fixSlot(slot: Node2D):
	var temp = 0
	for elem in slot.cards:
		elem.move_to_front()
		moveLib.move(elem, slot.global_position + Vector2(0,stackingDistance)*temp)
		temp = temp + 1
