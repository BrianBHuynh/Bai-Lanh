extends Node

func physAttack(card, target, damage):
	if is_instance_valid(target):
		var change = (damage-target.defense)
		if change > 0:
			target.health = target.health - change
		combat.combatBoard = combat.combatBoard + card.get_name() + " dealt " + str(damage) + " damage to " + target.get_name() + " They have " + str(target.health) + " health left! \n"
		moveLib.moveThenReturn(card, target.curPosition)
		if target.health <= 0:
			combat.kill(target)
			combat.combatBoard = combat.combatBoard + " Killing them!\n"

func lockDown(card, target):
	if is_instance_valid(target):
		moveLib.moveThenReturn(card, target.curPosition)
		combat.initiative.erase(target)
		combat.combatBoard = combat.combatBoard + target.get_name() + " has been locked down by " + card.get_name() + "\n"

func lifeStealLesser(card, target, damage):
	if is_instance_valid(target):
		var change = (damage-target.defense)
		if change > 0:
			target.health = target.health - change
			combat.combatBoard = combat.combatBoard + card.get_name() + " dealt " + str(change) + " damage to " + target.get_name() + " They have " + str(target.health) + " health left! \n" + card.get_name() + "healed for " + str(change/4) + " health! \n"
			card.health = card.health+(change/4)
		else:
			combat.combatBoard = combat.combatBoard + card.get_name() + " tried to hit  " + target.get_name() + " but did no damage! \n"
		moveLib.moveThenReturn(card, target.curPosition)
		if target.health <= 0:
			combat.kill(target)
			combat.combatBoard = combat.combatBoard + " Killing them! \n"

func multiPhysAttack(card, target, physAttack, diceMax, times):
	if is_instance_valid(target):
		combat.combatBoard = combat.combatBoard + card.get_name() + " lets out a flurry of blows! \n"
		var attacks = []
		for i in times:
			var change = (combat.RNG.randi_range(1,10)+physAttack) - target.defense
			if change > 0:
				target.health = target.health - change
				combat.combatBoard = combat.combatBoard + target.get_name() +  " -" + str(change) + " health\n"
				moveLib.moveThenReturn(card, target.curPosition)
			combat.combatBoard = combat.combatBoard + "They have " + str(target.health) + " health left! \n"
			if target.health <= 0:
				combat.kill(target)
				combat.combatBoard = combat.combatBoard + target.get_name() + " died! \n"

func batonPass(card, target):
	target.action()
	combat.combatBoard = combat.combatBoard + card.get_name() + "passes off the baton to " + target.get_name() + "\n"
