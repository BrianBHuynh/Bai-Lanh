extends Node2D

#Players and Opposing parties
var playerParty = []
var opposingParty = []

#Player positions
var playerFront = []
var playerMid = []
var playerBack = []
#Player roles
var playerTanks = []
var playerDps = []
var playerHealers = []

#Opponent positions
var opposingFront = []
var opposingMid = []
var opposingBack = []
#Opponent roles
var opposingTanks = []
var opposingDps = []
var opposingHealers = []

#Turn order
var initiative = []

#Used for complex agro calculation
var agroCalc = []

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
