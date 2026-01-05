extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	
	velocity = dir.normalized() * SPEED
	move_and_slide()
	
func add_to_inventory(type: String, quantity: int):
	InventoryManager.add_item(type, quantity)
