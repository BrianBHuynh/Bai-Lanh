extends Node2D

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
var playerHealers: Array = []

#Opponent positions
var opposingFront: Array = []
var opposingMid: Array = []
var opposingBack: Array = []
#Opponent roles
var opposingTanks: Array = []
var opposingDps: Array = []
var opposingHealers: Array = []

#Turn order
var initiative: Array = []

#Used for complex agro calculation
var agroCalc: Array = []

#returns next in initiative, if initiative is empty repopulates it
func getNext():
	if initiative.is_empty():
		recalcInitiative()
	return initiative.pop_front()

#Assumes both parties are alive and appends both to initiative, then shuffles. Multiplies occurance of each character by the amount of speed they have
func recalcInitiative():
	for i in playerParty.size():
		for j in playerParty[i].speed:
			initiative.append(playerParty[i])
	for i in opposingParty.size():
		for j in opposingParty[i].speed:
			initiative.append(opposingParty[i])
	initiative.shuffle()

func nextTurn():
	var curChar = getNext()
	curChar.attack

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
