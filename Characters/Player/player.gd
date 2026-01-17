extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_animation: AnimatedSprite2D = $sprite_animation


func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	
	var isGoingRight: bool = Input.is_action_pressed("move_right")
	var isGoingLeft: bool = Input.is_action_pressed("move_left")
	var isGoingUp: bool = Input.is_action_pressed("move_up")
	var isGoingDown: bool = Input.is_action_pressed("move_down")
	
	
	if isGoingRight or isGoingLeft or isGoingDown or isGoingUp:
		sprite_animation.play("walk")
		if isGoingRight:
			dir.x += 1
		if isGoingLeft:
			# the player has to face where it goes
			sprite_animation.flip_h = true
			dir.x -= 1
		if isGoingUp:
			dir.y -= 1
		if isGoingDown:
			dir.y += 1
		if not isGoingLeft:
			# reset of where the player look at
			sprite_animation.flip_h = false
	else:
		# reset of where the player look at
		sprite_animation.flip_h = false
		sprite_animation.play("idle")
	
	velocity = dir.normalized() * SPEED
	move_and_slide()
	
func add_to_inventory(item_id: String, item_name: String, quantity: int):
	InventoryManager.add_item(item_id, item_name, quantity)
