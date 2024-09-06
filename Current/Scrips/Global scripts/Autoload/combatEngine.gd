extends Node2D

#All slots are initialized here at the start of the scene
var slots = [] 

#Players and Opposing parties
var playerParty: Array = []
var opposingParty: Array = []

#Player positions
var playerFront: Array = []
var playerMid: Array = []
var playerBack: Array = []
#Player roles
var playerTanks: Array = []
var playerDps: Array = []
var playerSupport: Array = []

#Opponent positions
var opposingFront: Array = []
var opposingMid: Array = []
var opposingBack: Array = []

#Opponent roles
var opposingTanks: Array = []
var opposingDps: Array = []
var opposingSupport: Array = []

#Turn order
var initiative: Array = []

#Used for complex agro calculation
var agroCalc: Array = []

#RNG is pain
var RNG = RandomNumberGenerator.new()

var combatBoard = ""
var arrays: Array = [slots, playerParty, opposingParty, playerFront, playerMid, playerBack, playerTanks, playerDps, playerSupport, opposingFront, opposingMid, opposingBack, opposingTanks, opposingDps, opposingSupport, initiative, agroCalc]
#returns next in initiative, if initiative is empty repopulates it
func getInitiative():
	if initiative.is_empty():
		recalcInitiative()
	return initiative.pop_front()

func getNext(array):
	agroCalc.clear()
	agroCalc.append_array(array)
	agroCalc.shuffle()
	return agroCalc.pop_front()

#Assumes both parties are alive and appends both to initiative, then shuffles. Multiplies occurance of each character by the amount of speed they have
func recalcInitiative():
	for i in playerParty.size():
		for j in playerParty[i].speed:
			initiative.append(playerParty[i])
	for i in opposingParty.size():
		for j in opposingParty[i].speed:
			initiative.append(opposingParty[i])
	initiative.shuffle()

func addInitiative(card):
	for i in card.speed:
		initiative.append(card)
		initiative.shuffle()

func nextTurn():
	var curChar = getInitiative()
	if is_instance_valid(curChar):
		combatBoard = "It is " + str(curChar) + "'s turn!"
		curChar.action()

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

func kill(card):
	for array in arrays:
		while array.has(card):
			array.erase(card)
	for slot in slots:
		while slot.cardsList.has(card):
			slot.cardsList.erase(card)
	await get_tree().create_timer(.125).timeout
	card.queue_free()

func clearData():
	for array in arrays:
		array.clear()
	await get_tree().create_timer(.125).timeout
