extends Node

func phys_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = (damage-target.phys_defense)
		if change > 0:
			target.damage_physical(damage)
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(damage) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n"
		MoveLib.move_then_return(card, target.current_position)
		if target.health <= 0:
			target.kill()
			Combat.combat_board = Combat.combat_board + " Killing them!\n"

func mag_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = (damage-target.phys_defense)
		if change > 0:
			target.health = target.health - change
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(damage) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n"
		MoveLib.move_then_return(card, target.current_position)
		if target.health <= 0:
			target.kill()
			Combat.combat_board = Combat.combat_board + " Killing them!\n"

func life_steal_lesser(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = (damage-target.mag_defense)
		if change > 0:
			target.health = target.health - change
			Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n" + card.title + " healed for " + str(change/4) + " health! \n"
			card.health = card.health+(change/4)
		else:
			Combat.combat_board = Combat.combat_board + card.title + " tried to hit  " + target.title + " but did no damage! \n"
		MoveLib.move_then_return(card, target.current_position)
		if target.health <= 0:
			target.kill()
			Combat.combat_board = Combat.combat_board + " Killing them! \n"

func multi_phys_attack(card: Card, target: Card, diceMax: int, times: int) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + card.title + " lets out a flurry of blows! \n"
		for i in times:
				var change = (Combat.RNG.randi_range(1,diceMax)+card.phys_attack) - target.phys_defense
				if change > 0:
					target.health = target.health - change
					Combat.combat_board = Combat.combat_board + target.title +  " -" + str(change) + " health\n"
					MoveLib.move_then_return(card, target.current_position)
				Combat.combat_board = Combat.combat_board + "They have " + str(target.health) + " health left! \n"
		if target.health <= 0:
			target.kill()
			Combat.combat_board = Combat.combat_board + target.title + " died! \n"

func baton_pass(card, target) -> void:
	if is_instance_valid(target):
		target.action()
		Combat.combat_board = Combat.combat_board + card.title + "passes off the baton to " + target.title + "\n"

func poison(card, target, damage, duration) -> void:
	if is_instance_valid(card):
		var poison_status = StatusEffect.new("poison", duration, "every_turn", damage, target)
		Status.apply(poison_status)
		Combat.combat_board = Combat.combat_board + "Poison applied to" + target.title + "\n"
		MoveLib.move_then_return(card, target.current_position)

func lock_down(card, target) -> void:
	if is_instance_valid(target):
		var stun_status = StatusEffect.new("stun", 1, "on_turn", 0, target)
		Status.apply(stun_status)
		MoveLib.move_then_return(card, target.current_position)
		Combat.combat_board = Combat.combat_board + target.title + " has been locked down by " + card.title + "\n"

func self_heal(card, damage) -> void:
	if is_instance_valid(card):
		card.health = card.health + damage
