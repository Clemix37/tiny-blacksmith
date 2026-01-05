extends Node2D

# Scène du client à instancier
@export var customer_scene: PackedScene

# Positions importantes
@export var spawn_position: Vector2 = Vector2(100, 300)  # Où les clients apparaissent

# Positions de spawn (plusieurs points possibles)
@export var spawnPositions: Array[Marker2D] = []
# Positions du comptoir (plusieurs points possibles)
@export var counter_positions: Array[Marker2D] = []

# Paramètres de spawn
@export var min_spawn_interval: float = 5.0  # Temps min entre 2 clients
@export var max_spawn_interval: float = 15.0  # Temps max entre 2 clients
@export var max_customers: int = 3  # Nombre max de clients en même temps

# Variables internes
var spawn_timer: float = 0.0
var current_customers: Array = []
var occupied_counter_positions: Array = []  # Positions déjà occupées

func _ready():
	if spawnPositions.size() == 0:
		push_error("No spawn positions")
	if counter_positions.size() == 0:
		push_error("No counter positions")
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
	# Vérifier s'il reste des positions libres
	if occupied_counter_positions.size() >= counter_positions.size():
		print("Toutes les positions du comptoir sont occupées")
		return
	
	# Créer une instance du client
	var customer = customer_scene.instantiate()
	
	# Positionner le client
	customer.global_position = get_random_spawn_position()
	
	# Choisir une position libre au comptoir
	var available_positions = []
	for counterSpawn in counter_positions:
		if counterSpawn.position not in occupied_counter_positions:
			available_positions.append(counterSpawn.position)
	
	if available_positions.is_empty():
		customer.queue_free()
		return
	
	var chosen_position = available_positions[randi() % available_positions.size()]
	occupied_counter_positions.append(chosen_position)
	
	# Initialiser avec la position du comptoir choisie
	customer.initialize(chosen_position)
	
	# Connecter les signaux
	customer.customer_leaving.connect(_on_customer_leaving.bind(customer, chosen_position))
	
	# Ajouter à la scène
	get_parent().add_child(customer)
	current_customers.append(customer)
	
	print("Nouveau client spawné à la position ", chosen_position, " ! Total: ", current_customers.size())

func reset_spawn_timer():
	spawn_timer = randf_range(min_spawn_interval, max_spawn_interval)

func _on_customer_leaving(customer, counter_pos: Vector2):
	# Retirer le client de la liste
	current_customers.erase(customer)
	
	# Libérer la position du comptoir
	occupied_counter_positions.erase(counter_pos)
	
	print("Client parti. Clients restants: ", current_customers.size())

# Fonction pour servir le client le plus proche du comptoir
func serve_nearest_customer() -> bool:
	if current_customers.is_empty():
		print("Aucun client à servir")
		return false
	
	# Trouver le client le plus proche du comptoir (n'importe quelle position)
	var nearest_customer = null
	var min_distance = INF
	
	for customer in current_customers:
		for counter_pos in counter_positions:
			var distance = customer.global_position.distance_to(counter_pos)
			if distance < min_distance and customer.current_state == customer.State.WAITING:
				min_distance = distance
				nearest_customer = customer
	
	if nearest_customer:
		return nearest_customer.serve_customer()
	
	return false

func get_random_spawn_position() -> Vector2:
	var positions = []
	for spawn in spawnPositions:
		positions.append(spawn.position)
	return positions[randi() % positions.size()]
