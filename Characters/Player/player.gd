extends Area2D

var health = 100 #health amount of player
var attack = 20 #attack value of the player
var defense = 20 #defense of the player
var pref_Pos = "None" #prefered possition of the player
var draggable = false #If the card is draggable at that moment
var slotted = 0 #Slotted is a int because sometimes multiple slots overlap or are placed close to eachother
var slotRef #Where the latest slot is stored
var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #The initial position of the card before moving
var curRef #Where the current slot / location is stored
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
			GlobalVars.dragging_card = false
			var tween = get_tree().create_tween()
			if slotted > 0 && is_instance_valid(slotRef) && not slotRef.filled:
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
	slotRef = slot

#Decriments the slotted variable, then returns the slot back to it's default color
func removeSlot():
	slotted = slotted - 1
	if slotted == 0:
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.ALICE_BLUE, 1)

#Makes card draggable and shows that it is to player by changing color and size
func selectCard():
	if not GlobalVars.dragging_card:
		draggable = true
		scale = Vector2(1.1, 1.1)
		modulate = Color(Color.ALICE_BLUE, 1)

#Returns card back to normal
func unselectCard():
	if not GlobalVars.dragging_card:
		draggable = false
		modulate = defaultColor
		scale = defaultSize

#Moves card to front, calculates offset and initial position of card, sets dragging to be true
func pickupCard():
	offset = get_global_mouse_position() - global_position
	initialPos = global_position
	GlobalVars.dragging_card = true
	modulate = Color(Color.LIGHT_GOLDENROD, 1.5);
	move_to_front()

#Updates card location
func holdCard():
	global_position = get_global_mouse_position() - offset

#Moves card location to the slot's position, places card into the party, unfills the old slot if it exist, changes current slot to new slot and fills it
func placeCard(tween: Tween):
	tween.tween_property(self,"position",slotRef.position,0.2).set_ease(Tween.EASE_OUT)
	GlobalVars.player_party.append(self)
	if is_instance_valid(curRef):
		curRef.filled = false
	curRef = slotRef
	curRef.filled = true

#returns card back to old position when picking up
func returnCard(tween: Tween):
	tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
