extends CanvasLayer

# Référence au container qui contiendra les items
@onready var item_list = $Panel/VBoxContainer/ScrollContainer/VBoxContainer

func _ready():
	# Se connecter au signal de l'inventory_manager
	if InventoryManager.has_signal("inventory_updated"):
		InventoryManager.inventory_updated.connect(_on_inventory_updated)
	
	# Afficher l'inventaire initial
	update_inventory_display(InventoryManager.inventory)
	
	# Optionnel: cacher au démarrage
	visible = false

func _process(_delta):
	# Optionnel: touche pour ouvrir/fermer l'inventaire
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory_display()

func toggle_inventory_display():
	visible = !visible

func _on_inventory_updated(inventory: Dictionary):
	update_inventory_display(inventory)

func update_inventory_display(inventory: Dictionary):
	print(inventory)
	# Supprimer tous les anciens labels
	for child in item_list.get_children():
		child.queue_free()
	
	# Si l'inventaire est vide
	if inventory.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Empty inventory..."
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_list.add_child(empty_label)
		return
	
	# Créer un label pour chaque item
	for item_type in inventory.keys():
		var quantity = inventory[item_type]
		
		# Créer un HBoxContainer pour aligner l'icône, le nom et la quantité
		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size.y = 32
		
		# Optionnel: Icône de l'item
		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(24, 24)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		# Charger l'icône si elle existe
		var icon_path = "res://assets/icons/" + item_type + ".png"
		if ResourceLoader.exists(icon_path):
			icon.texture = load(icon_path)
		hbox.add_child(icon)
		
		# Label pour le nom de l'item
		var item_label = Label.new()
		item_label.text = item_type
		item_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		# Label pour la quantité
		var quantity_label = Label.new()
		quantity_label.text = "x" + str(quantity)
		quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		quantity_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		quantity_label.custom_minimum_size = Vector2(60, 0)
		
		# Ajouter les éléments au HBoxContainer
		hbox.add_child(item_label)
		hbox.add_child(quantity_label)
		
		# Ajouter le HBoxContainer à la liste
		item_list.add_child(hbox)
		
		# Optionnel: ajouter un séparateur
		var separator = HSeparator.new()
		item_list.add_child(separator)
