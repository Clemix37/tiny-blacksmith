extends Node2D

@export var pickup_effect_scene: PackedScene
@export var item_container: ItemContainerResource
@onready var label: Label = $Label
@onready var areaDetection: Area2D = $PlayerDetection/Area2D
@onready var chest: Node2D = $Chest

var playerInArea = false
var playerReference = null
var giveTimer: float = 0.0
var quantity: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quantity = ContainersManager.get_container_quantity(item_container.id_container)
	_updateLabels()
	areaDetection.body_entered.connect(_on_body_entered)
	areaDetection.body_exited.connect(_on_body_exited)
	
func _process(delta: float) -> void:
	# Si le joueur est dans la zone et qu'il reste des items
	if playerInArea and item_container.quantity > 0:
		giveTimer += delta
		
		# Donner 1 item toutes les give_rate secondes
		if giveTimer >= item_container.give_rate:
			give_item_to_player()
			giveTimer = 0.0

func _updateLabels() -> void:
	label.text = item_container.game_resource.name + " x" + str(quantity) + ""
	
func give_item_to_player():
	# Pas de joueur ou plus de quantité
	if !playerReference or item_container.quantity == 0: return
	var resource: GameResource = item_container.game_resource
	playerReference.add_to_inventory(resource.id, resource.name, 1)
	item_container.remove_quantity(1)
	_updateLabels()
	spawn_pickup_effect()

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("add_to_inventory"):
		_open_container()
		playerInArea = true
		giveTimer = 0.0 # Donne immédiatement le premier item
		playerReference = body
		give_item_to_player()

func _on_body_exited(body):
	if body.name == "Player":
		_close_container()
		playerInArea = false
		giveTimer = 0.0
		playerReference = null

func spawn_pickup_effect():
	var effect = pickup_effect_scene.instantiate()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)

func _open_container():
	chest.open()

func _close_container():
	chest.close()
