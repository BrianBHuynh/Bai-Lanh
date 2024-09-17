extends Node

func phys_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_physical(damage)
		Combat.combat_board = card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n" + Combat.combat_board
		MoveLib.move_then_return(card, target.current_position)

func mag_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_magical(damage)
		Combat.combat_board = card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n" + Combat.combat_board
		MoveLib.move_then_return(card, target.current_position)

func mag_life_steal_lesser(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_magical(damage)
		Combat.combat_board = card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(target.health) + " health left! \n" + card.title + " healed for " + str(change/4.0) + " health! \n" + Combat.combat_board
		card.health = card.health+(change/4.0)
		MoveLib.move_then_return(card, target.current_position)

func multi_phys_attack(card: Card, target: Card, diceMax: int, times: int) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + card.title + " lets out a flurry of blows! \n"
		for i in times:
			var change = target.damage_physical(Combat.RNG.randi_range(1,diceMax)+card.phys_attack)
			target.health = target.health - change
			Combat.combat_board = target.title +  " -" + str(change) + " health\n" + Combat.combat_board
			MoveLib.move_then_return(card, target.current_position)
		Combat.combat_board = Combat.combat_board + "They have " + str(target.health) + " health left! \n"

func baton_pass(card, target) -> void:
	if is_instance_valid(target):
		target.action()
		Combat.combat_board = card.title + "passes off the baton to " + target.title + "\n" + Combat.combat_board 

func poison(card, target, damage, duration) -> void:
	if is_instance_valid(card):
		var poison_status = StatusEffect.new("poison", duration, "every_turn", damage, target)
		Status.apply(poison_status)
		Combat.combat_board = "Poison applied to" + target.title + "\n" + Combat.combat_board
		MoveLib.move_then_return(card, target.current_position)

func lock_down(card, target) -> void:
	if is_instance_valid(target):
		var stun_status = StatusEffect.new("slow", target.speed, "every_turn", 2, target)
		Status.apply(stun_status)
		MoveLib.move_then_return(card, target.current_position)
		Combat.combat_board = target.title + " has been locked down by " + card.title + "\n" + Combat.combat_board

func self_heal(card, damage) -> void:
	if is_instance_valid(card):
		card.health = card.health + damage
