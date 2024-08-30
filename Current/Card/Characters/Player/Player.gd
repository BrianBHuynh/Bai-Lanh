extends Area2D

var health = 100 #Health amount of card
var attack = 10 #Attack value of the card
var defense = 10 #Defense of the card
var speed = 10 #Speed of the card

#Position stats/effects should only be applied when the play button is pressed!
var prefPos = "None" #Prefered possition of the card
var pos = "None" #Current position
var posHealth = 0
var posAttack = 0
var posDefense = 0
var posSpeed = 0

var draggable = false #If the card is draggable at that moment
var slotted = 0 #Slotted is a int because sometimes multiple slots overlap or are placed close to eachother
var newSlot #Where the latest slot is stored
var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #The initial position of the card before moving
var curSlot #Where the current slot / location is stored
var defaultColor = modulate #for default color
var defaultSize = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if draggable: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable
		if Input.is_action_just_pressed("leftClick"):
			pickupCard()
		if Input.is_action_pressed("leftClick"):
			holdCard()
		elif Input.is_action_just_released("leftClick"):
			modulate = defaultColor;
			globalVars.draggingCard = false
			var tween = get_tree().create_tween()
			if slotted > 0 && is_instance_valid(newSlot) && not newSlot.filled:
				placeCard(tween)
			else:
				returnCard(tween)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		addSlot(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		removeSlot()

func _on_mouse_entered() -> void:
	selectCard()

func _on_mouse_exited() -> void:
	unselectCard()

#Places the location of the Slot into slot ref and changes its color, incriments the slot int
func addSlot(slot: Node2D):
	slotted = slotted + 1
	slot.modulate = Color(Color.SKY_BLUE, 2)
	slot.scale = Vector2(1.1,1.1)
	newSlot = slot

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot():
	slotted = slotted - 1
	if slotted == 0:
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.ALICE_BLUE, 1)

#Makes card draggable and shows that it is to player by changing color and size
func selectCard():
	if not globalVars.draggingCard:
		draggable = true
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.ALICE_BLUE, 1)

#Returns card back to normal
func unselectCard():
	if not globalVars.draggingCard:
		draggable = false
		modulate = defaultColor
		scale = defaultSize

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickupCard():
	offset = get_global_mouse_position() - global_position
	initialPos = global_position
	globalVars.draggingCard = true
	modulate = Color(Color.LIGHT_GOLDENROD, 1.5);
	move_to_front()

#Updates card location
func holdCard():
	global_position = get_global_mouse_position() - offset

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeCard(tween: Tween):
	tween.tween_property(self,"position",newSlot.position,0.2).set_ease(Tween.EASE_OUT)
	if is_instance_valid(curSlot):
		curSlot.filled = false
	curSlot = newSlot
	curSlot.filled = true
	if not combat.playerParty.has(self):
		combat.playerParty.append(self)

#returns card back to old position when picking up
func returnCard(tween: Tween):
	tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)

#Applies slot stats and effects
func slotApply():
	health = health + curSlot.slotHealth
	attack = attack + curSlot.slotAttack
	defense = defense + curSlot.slotDefense
	speed = speed + curSlot.slotSpeed
	curSlot.activate()

func posApply():
	if prefPos == curSlot.pos:
		health = health + posHealth
		attack = attack + posAttack
		defense = defense + posDefense
		speed = speed + posSpeed
		posEffect()

func posEffect():
	pass
