extends CharacterBody2D

# Paramètres du client
@export var move_speed: float = 100.0
@export var wait_time: float = 5.0  # Temps d'attente au comptoir

# Apparence du client
var customer_sprites = [
	"res://Assets/Customers/01/tile_0024.png",
	"res://Assets/Customers/02/tile_0105.png",
	"res://Assets/Customers/03/tile_0186.png",
	"res://Assets/Customers/04/tile_0267.png",
	"res://Assets/Customers/04/tile_0348.png",
	"res://Assets/Customers/04/tile_0429.png",
]

# Items possibles que le client peut demander
var possible_items = Data.ResourcesNameArray
var requested_recipe: RecipeManager.Recipe = null

# État du client
enum State { WALKING_TO_COUNTER, WAITING, LEAVING, SERVED }
var current_state = State.WALKING_TO_COUNTER

# Positions
var target_position: Vector2
var spawn_position: Vector2
var counter_position: Vector2

# Timers
var wait_timer: float = 0.0

# Références
@onready var sprite = $Sprite2D if has_node("Sprite2D") else null
@onready var label: Label = $Label
@onready var timerLabel: Label = $TimerLabel
@onready var collisionArea: Area2D = $Area2D

signal customer_arrived
signal customer_leaving
signal customer_served(item: String, quantity: int)

func _ready():
	# Générer une demande aléatoire
	generate_request()
	
	# Enregistrer la position de spawn
	spawn_position = global_position
	
	# Cacher les labels au début
	timerLabel.visible = false
	label.visible = false
	
	# Appliquer un sprite/couleur aléatoire
	randomize_appearance()
	collisionArea.body_entered.connect(_on_body_entered)

func randomize_appearance():
	if sprite:
		# Essayer de charger un sprite aléatoire
		var sprite_index = randi() % customer_sprites.size()
		var sprite_path = customer_sprites[sprite_index]
		
		if ResourceLoader.exists(sprite_path):
			sprite.texture = load(sprite_path)

func initialize(counter_pos: Vector2):
	counter_position = counter_pos
	target_position = counter_position

func generate_request():
	# Choisir un item aléatoire
	requested_recipe = RecipeManager.get_random_recipe()
	wait_time = 30
	
	label.text = requested_recipe.name.capitalize() + " (+" + str(requested_recipe.reward) + "$)"

func _physics_process(delta):
	match current_state:
		State.WALKING_TO_COUNTER:
			walk_to_counter(delta)
		
		State.WAITING:
			wait_at_counter(delta)
		
		State.LEAVING:
			leave_shop(delta)
		
		State.SERVED:
			leave_shop(delta)

func walk_to_counter(delta):
	# Se déplacer vers le comptoir
	var direction = (target_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	# Vérifier si arrivé au comptoir
	if global_position.distance_to(target_position) < 30:
		arrive_at_counter()

func arrive_at_counter():
	current_state = State.WAITING
	velocity = Vector2.ZERO
	wait_timer = wait_time
	
	print(label)
	# Afficher la demande
	_toggle_labels_visibility(true)
	
	emit_signal("customer_arrived")

func wait_at_counter(delta):
	wait_timer -= delta
	_update_timer_label()
	
	# Si le temps d'attente est écoulé, partir mécontent
	if wait_timer <= 0:
		print("Client parti sans être servi...")
		current_state = State.LEAVING
		target_position = spawn_position
		_toggle_labels_visibility(false)

func serve_customer() -> bool:
	# Client déjà servi, ne rien faire
	if current_state == State.SERVED: return false
	var quantity := 1
	# Vérifier si le joueur a les items demandés
	if InventoryManager.has_item(requested_recipe.id, quantity):
		# Retirer les items de l'inventaire
		InventoryManager.remove_item(requested_recipe.id, quantity)
		
		label.text = "Merci !"
		await get_tree().create_timer(1.0).timeout
		# Client satisfait
		current_state = State.SERVED
		target_position = spawn_position
		_toggle_labels_visibility(false)
		
		emit_signal("customer_served", requested_recipe, quantity)
		
		InventoryManager.add_money(requested_recipe.reward)
		
		return true
	else:
		print("Pas assez d'items dans l'inventaire...")
		label.text = "Pas assez..."
		await get_tree().create_timer(1.0).timeout
		label.text = requested_recipe.name.capitalize()
		return false

func leave_shop(delta):
	# Se déplacer vers la sortie
	var direction = (target_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	# Vérifier si sorti du magasin
	if global_position.distance_to(target_position) < 30:
		queue_free()  # Supprimer le client

# Détection du joueur quand il rentre dans la zone de service
func _on_body_entered(body) -> void:
	if body.name == "Player":
		serve_customer()

# Mets à jour l'affichage du compteur
func _update_timer_label() -> void:
	timerLabel.text = str(roundi(wait_timer)) + "s"

func _toggle_labels_visibility(label_visible: bool) -> void:
	label.visible = label_visible
	timerLabel.visible = label_visible
