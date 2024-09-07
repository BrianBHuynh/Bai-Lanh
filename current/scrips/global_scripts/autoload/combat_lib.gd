extends Node

func phys_attack(card, target, damage):
	if is_instance_valid(target):
		var change = (damage-target.phys_defense)
		if change > 0:
			target.health = target.health - change
		combat.combat_board = combat.combat_board + card.get_name() + " dealt " + str(damage) + " damage to " + target.get_name() + " They have " + str(target.health) + " health left! \n"
		move_lib.moveThenReturn(card, target.cur_position)
		if target.health <= 0:
			combat.kill(target)
			combat.combat_board = combat.combat_board + " Killing them!\n"

func lockDown(card, target):
	if is_instance_valid(target):
		move_lib.moveThenReturn(card, target.cur_position)
		combat.initiative.erase(target)
		combat.combat_board = combat.combat_board + target.get_name() + " has been locked down by " + card.get_name() + "\n"

func lifeStealLesser(card, target, damage):
	if is_instance_valid(target):
		var change = (damage-target.defense)
		if change > 0:
			target.health = target.health - change
			combat.combat_board = combat.combat_board + card.get_name() + " dealt " + str(change) + " damage to " + target.get_name() + " They have " + str(target.health) + " health left! \n" + card.get_name() + "healed for " + str(change/4) + " health! \n"
			card.health = card.health+(change/4)
		else:
			combat.combat_board = combat.combat_board + card.get_name() + " tried to hit  " + target.get_name() + " but did no damage! \n"
		move_lib.moveThenReturn(card, target.cur_position)
		if target.health <= 0:
			combat.kill(target)
			combat.combat_board = combat.combat_board + " Killing them! \n"

func multiPhys_attack(card, target, phys_attack, diceMax, times):
	if is_instance_valid(target):
		combat.combat_board = combat.combat_board + card.get_name() + " lets out a flurry of blows! \n"
		var attacks = []
		for i in times:
			var change = (combat.RNG.randi_range(1,10)+phys_attack) - target.defense
			if change > 0:
				target.health = target.health - change
				combat.combat_board = combat.combat_board + target.get_name() +  " -" + str(change) + " health\n"
				move_lib.moveThenReturn(card, target.cur_position)
			combat.combat_board = combat.combat_board + "They have " + str(target.health) + " health left! \n"
			if target.health <= 0:
				combat.kill(target)
				combat.combat_board = combat.combat_board + target.get_name() + " died! \n"

func batonPass(card, target):
	target.action()
	combat.combat_board = combat.combat_board + card.get_name() + "passes off the baton to " + target.get_name() + "\n"
