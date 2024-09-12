extends Node

func phys_attack(card, target, damage) -> void:
	if is_instance_valid(target):
		var change = (damage-target.phys_defense)
		if change > 0:
			target.health = target.health - change
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(damage) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n"
		MoveLib.move_then_return(card, target.current_position)
		if target.health <= 0:
			Combat.kill(target)
			Combat.combat_board = Combat.combat_board + " Killing them!\n"

func lock_down(card, target) -> void:
	if is_instance_valid(target):
		MoveLib.move_then_return(card, target.current_position)
		Combat.initiative.erase(target)
		Combat.combat_board = Combat.combat_board + target.title + " has been locked down by " + card.title + "\n"

func life_steal_lesser(card, target, damage) -> void:
	if is_instance_valid(target):
		var change = (damage-target.defense)
		if change > 0:
			target.health = target.health - change
			Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n" + card.title + "healed for " + str(change/4) + " health! \n"
			card.health = card.health+(change/4)
		else:
			Combat.combat_board = Combat.combat_board + card.title + " tried to hit  " + target.title + " but did no damage! \n"
		MoveLib.move_then_return(card, target.current_position)
		if target.health <= 0:
			Combat.kill(target)
			Combat.combat_board = Combat.combat_board + " Killing them! \n"

func multi_phys_attack(card, target, phys_attack_stat, diceMax, times) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + card.title + " lets out a flurry of blows! \n"
		var attacks = []
		for i in times:
			var change = (Combat.RNG.randi_range(1,10)+phys_attack_stat) - target.phys_defense
			if change > 0:
				target.health = target.health - change
				Combat.combat_board = Combat.combat_board + target.title +  " -" + str(change) + " health\n"
				MoveLib.move_then_return(card, target.current_position)
			Combat.combat_board = Combat.combat_board + "They have " + str(target.health) + " health left! \n"
			if target.health <= 0:
				Combat.kill(target)
				Combat.combat_board = Combat.combat_board + target.title + " died! \n"

func baton_pass(card, target) -> void:
	target.action()
	Combat.combat_board = Combat.combat_board + card.title + "passes off the baton to " + target.title + "\n"
