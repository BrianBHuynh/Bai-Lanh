extends Node

func physAttack(card, target, damage):
	if is_instance_valid(target):
		var change = (damage-target.defense)
		if change > 0:
			target.health = target.health - (damage-target.defense)
		combat.combatBoard = combat.combatBoard + card.get_name() + " dealt " + str(damage) + " damage to " + target.get_name() + "They have " + str(target.health) + " health left!"
		moveLib.moveThenReturn(card, target.curPosition)
		if target.health <= 0:
			combat.kill(target)
			combat.combatBoard = combat.combatBoard + " Killing them!"

func lockDown(card, target):
	if is_instance_valid(target):
		moveLib.moveThenReturn(card, target.curPosition)
		combat.initiative.erase(target)
		combat.combatBoard = combat.combatBoard + target.get_name() + " has been locked down by " + card.get_name() 
