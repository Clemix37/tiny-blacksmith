extends Node2D

# Scène du client à instancier
@export var customer_scene: PackedScene

# Positions de spawn (plusieurs points possibles)
@export var spawnPositions: Array[Marker2D] = []
@export var y_spawn_position: int = -260
@export var min_x_position: int = -135
@export var max_x_position: int = 1225
@export var y_counter: int

# Paramètres de spawn
@export var min_spawn_interval: float = 5.0  # Temps min entre 2 clients
@export var max_spawn_interval: float = 15.0  # Temps max entre 2 clients
@export var max_customers: int = 3  # Nombre max de clients en même temps

# Variables internes
var spawn_timer: float = 0.0
var current_customers: Array = []

func _ready():
	# Charger la scène du client si pas définie
	if not customer_scene:
		customer_scene = load("res://customer.tscn")
	
	# Définir le premier délai
	reset_spawn_timer()

func _process(delta):
	spawn_timer -= delta
	
	# Vérifier si on peut spawner un nouveau client
	if spawn_timer <= 0 and current_customers.size() < max_customers:
		spawn_customer()
		reset_spawn_timer()

func spawn_customer():
	# Créer une instance du client
	var customer = customer_scene.instantiate()
	
	# Positionner le client
	customer.global_position = get_random_spawn_position()
	
	# Choix de la position à occuper par le client
	var chosen_position = Vector2(randi_range(min_x_position, max_x_position), y_counter)
	# Initialiser avec la position du comptoir choisie et son point d'entrée
	customer.initialize(chosen_position)
	
	# Connecter les signaux
	customer.customer_leaving.connect(_on_customer_leaving.bind(customer))
	
	# Ajouter à la scène
	get_parent().add_child(customer)
	current_customers.append(customer)
	
	print("Nouveau client spawné à la position ", chosen_position, " ! Total: ", current_customers.size())

func reset_spawn_timer():
	spawn_timer = randf_range(min_spawn_interval, max_spawn_interval)

func _on_customer_leaving(customer):
	# Retirer le client de la liste
	current_customers.erase(customer)
	print("Client parti. Clients restants: ", current_customers.size())

func get_random_spawn_position() -> Vector2:
	return Vector2(randi_range(min_x_position, max_x_position), y_spawn_position)
