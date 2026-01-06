extends Node2D

@onready var interactionLabel: Label = $InteractionArea/Label
@onready var interactionArea: Area2D = $InteractionArea
@onready var forge_panel: Panel = $UI/ForgePanel
@onready var recipes_list: VBoxContainer = $UI/ForgePanel/MarginContainer/VBoxContainer/RecipesContainer/RecipesList
@onready var recipe_name_label: Label = $UI/ForgePanel/MarginContainer/VBoxContainer/SelectedRecipeInfo/RecipeNameLabel
@onready var required_items_label: Label = $UI/ForgePanel/MarginContainer/VBoxContainer/SelectedRecipeInfo/RequiredItemsLabel
@onready var result_label: Label = $UI/ForgePanel/MarginContainer/VBoxContainer/SelectedRecipeInfo/ResultLabel
@onready var forge_button: Button = $UI/ForgePanel/MarginContainer/VBoxContainer/ButtonsContainer/HBoxContainer/ForgeButton
@onready var close_button: Button = $UI/ForgePanel/MarginContainer/VBoxContainer/ButtonsContainer/HBoxContainer2/CloseButton

var playerInArea = false
var playerReference = null
var selected_recipe = null
var recipe_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# interactions
	interactionArea.body_entered.connect(_on_interaction_area_entered)
	interactionArea.body_exited.connect(_on_interaction_area_exited)
	forge_button.pressed.connect(_on_forge_btn_pressed)
	close_button.pressed.connect(_on_close_btn_pressed)
	# Connecter le signal du RecipeManager
	RecipeManager.recipe_crafted.connect(_on_recipe_crafted)
	
	interactionLabel.visible = false
	forge_panel.visible = false
	
	# Créer les boutons de recettes
	create_recipe_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerInArea and Input.is_action_just_pressed("interact"):
		toggle_forge_ui()
	
func _on_interaction_area_entered(body):
	if body.is_in_group("player") or body.name == "Player":
		playerInArea = true
		playerReference = body
		interactionLabel.visible = true

func _on_interaction_area_exited(body):
	if body.is_in_group("player") or body.name == "Player":
		playerInArea = false
		playerReference = null
		interactionLabel.visible = false
		close_forge_ui()

func toggle_forge_ui():
	forge_panel.visible = !forge_panel.visible

func close_forge_ui():
	forge_panel.visible = false
	selected_recipe = null

func _on_forge_btn_pressed():
	if selected_recipe == null or !selected_recipe.can_craft():
		return
	for item_index in selected_recipe.requirements.keys():
		var item_type: String = Data.ResourcesNameArray[item_index]
		var quantity: int = selected_recipe.requirements[item_index]
		InventoryManager.remove_item(item_type, quantity)
	InventoryManager.add_item(selected_recipe.name, 1)
	selected_recipe = null
	update_recipe_availability()
	update_selected_recipe_display()
	
func _on_close_btn_pressed():
	close_forge_ui()

func create_recipe_buttons():
	# Supprimer les anciens boutons
	for child in recipes_list.get_children():
		child.queue_free()
	
	recipe_buttons.clear()
	
	# Obtenir les recettes à afficher
	var recipes_to_show: Array[RecipeManager.Recipe] = RecipeManager.get_all_recipes()
	
	# Créer un bouton pour chaque recette
	for recipe in recipes_to_show:
		var button = Button.new()
		button.text = recipe.name
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.custom_minimum_size = Vector2(0, 40)
		
		# Connecter le signal avec l'ID de la recette
		button.pressed.connect(_on_recipe_button_pressed.bind(recipe.id))
		
		recipes_list.add_child(button)
		recipe_buttons.append({"button": button, "recipe_id": recipe.id})
	
	print("Créé ", recipe_buttons.size(), " boutons de recettes")

func update_selected_recipe_display():
	if selected_recipe == null:
		recipe_name_label.text = "Sélectionnez une recette"
		required_items_label.text = ""
		result_label.text = ""
		forge_button.disabled = true
		return
	
	# Afficher le nom
	recipe_name_label.text = selected_recipe.name
	
	# Afficher les ressources nécessaires
	var requirements_text = "Nécessite:\n"
	var can_craft = selected_recipe.can_craft()
	
	for item_index in selected_recipe.requirements.keys():
		var item_type: String = Data.ResourcesNameArray[item_index]
		var required_qty = selected_recipe.requirements[item_index]
		var available_qty = InventoryManager.get_item_count(item_type)
		
		var item_name = RecipeManager.format_item_name(item_type)
		requirements_text += "  • " + item_name + ": " + str(available_qty) + "/" + str(required_qty)
		
		if available_qty < required_qty:
			requirements_text += " ❌\n"
		else:
			requirements_text += " ✓\n"
	
	required_items_label.text = requirements_text
	
	# Afficher le résultat
	var result_name = RecipeManager.format_item_name(selected_recipe.result_item)
	result_label.text = "Résultat: " + result_name + " x" + str(selected_recipe.result_quantity)
	
	# Activer/désactiver le bouton de forge
	forge_button.disabled = !can_craft

func update_recipe_availability():
	# Mettre à jour l'affichage de disponibilité de toutes les recettes
	for button_data in recipe_buttons:
		var button = button_data.button
		var recipe = RecipeManager.get_recipe(button_data.recipe_id)
		
		if recipe == null:
			continue
		
		# Changer le style du bouton selon la disponibilité
		if recipe.can_craft():
			button.modulate = Color.WHITE
		else:
			button.modulate = Color(0.5, 0.5, 0.5)  # Grisé
	
	# Mettre à jour l'affichage de la recette sélectionnée
	if selected_recipe:
		update_selected_recipe_display()

func _on_recipe_crafted(recipe_id: String, result_item: String, quantity: int):
	print("Recette craftée via signal: ", recipe_id)
	# Ici tu peux ajouter des effets visuels, sons, etc.

func play_forge_animation():
	# Animation de forge (particules, flash, son)
	pass

func _on_recipe_button_pressed(recipe_id: String):
	selected_recipe = RecipeManager.get_recipe(recipe_id)
	update_selected_recipe_display()
