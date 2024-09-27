extends Node
class_name CombatLib

static func phys_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_physical(damage+card.phys_attack)
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(int(target.health)) + " health left! \n" 
		MoveLib.move_then_return(card, target.current_position)

static func mag_attack(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_magical(damage+card.mag_attack)
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(int(target.health)) + " health left! \n" 
		MoveLib.move_then_return(card, target.current_position)

static func mag_life_steal_lesser(card: Card, target: Card, damage: int) -> void:
	if is_instance_valid(target):
		var change = target.damage_magical(damage+card.mag_attack)
		Combat.combat_board = Combat.combat_board + card.title + " dealt " + str(change) + " damage to " + target.title + " They have " + str(int(target.health)) + " health left! \n" + card.title + " healed for " + str(change/4.0) + " health! \n" 
		card.health = card.health+(change/4.0)
		MoveLib.move_then_return(card, target.current_position)

static func multi_phys_attack(card: Card, target: Card, diceMax: int, times: int) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + card.title + " lets out a flurry of blows! \n"
		for i in times:
			var change = target.damage_physical(Combat.RNG.randi_range(1,diceMax)+card.phys_attack)
			Combat.combat_board = Combat.combat_board + target.title +  " -" + str(change) + " health\n"
			MoveLib.move_then_return(card, target.current_position)
		Combat.combat_board = Combat.combat_board + "They have " + str(int(target.health)) + " health left! \n"

static func baton_pass(card: Card, target:Card) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + card.title + "passes off the baton to " + target.title + "\n" 
		target.action()

static func poison(card:Card, target:Card, damage:int, duration:int) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + "Poison applied to" + target.title + "\n" + "They will take " + str(damage) + " damage every turn for " + str(duration) + " turns \n" 
		var status = StatusEffect.new("poison", duration, "every_turn", damage, target)
		Status.apply(status)
		MoveLib.move_then_return(card, target.current_position)

static func lock_down(card:Card, target:Card) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + target.title + " has been locked down by " + card.title + "\n"
		var status = StatusEffect.new("slow", 2, "every_turn", target.speed, target)
		Status.apply(status)
		MoveLib.move_then_return(card, target.current_position)

static func self_heal(card:Card, health) -> void:
	if is_instance_valid(card):
		card.health = card.health + health
		Combat.combat_board = Combat.combat_board + card.title + " healed " + str(health) + " health! \n" 

static func phys_defense_up(card:Card, target:Card) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + target.title + "'s defense rises ! \n" 
		var status = StatusEffect.new("phys_defense_up", 3, "on_turn", 3, target)
		Status.apply(status)
		MoveLib.change_scale(target, Vector2(1.5,1.5))
		MoveLib.change_color(target, Color.AQUAMARINE)
		await Combat.get_tree().create_timer(1.0).timeout
		if is_instance_valid(target):
			MoveLib.change_scale(target, target.default_size)
			MoveLib.change_color(target, target.default_color)

static func phys_attack_up(card:Card, target:Card) -> void:
	if is_instance_valid(target):
		Combat.combat_board = Combat.combat_board + target.title + "'s attack rises ! \n" 
		var status = StatusEffect.new("phys_attack_up", 3, "on_turn", 3, target)
		Status.apply(status)
		MoveLib.change_scale(target, Vector2(1.5,1.5))
		MoveLib.change_color(target, Color.PALE_VIOLET_RED)
		await Combat.get_tree().create_timer(1.0).timeout
		if is_instance_valid(target):
			MoveLib.change_scale(target, target.default_size)
			MoveLib.change_color(target, target.default_color)
