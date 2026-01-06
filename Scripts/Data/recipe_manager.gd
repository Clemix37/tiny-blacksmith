extends Node

# Classe pour définir une recette
class Recipe:
	var id: String  # Identifiant unique
	var name: String  # Nom affiché
	var result_item: String  # Item produit
	var result_quantity: int  # Quantité produite
	var requirements: Dictionary  # {item_type: quantity}
	var category: String  # Catégorie (optionnel)
	var unlock_level: int  # Niveau requis (optionnel)
	
	func _init(p_id: String, p_name: String, p_result: String, p_quantity: int, p_requirements: Dictionary, p_category: String = "general", p_level: int = 0):
		id = p_id
		name = p_name
		result_item = p_result
		result_quantity = p_quantity
		requirements = p_requirements
		category = p_category
		unlock_level = p_level
	
	# Vérifier si le joueur a les ressources nécessaires
	func can_craft() -> bool:
		for item_index in requirements.keys():
			var item_type: String = Data.ResourcesNameArray[item_index]
			var required_qty = requirements[item_index]
			print(item_type)
			if not InventoryManager.has_item(item_type, required_qty):
				return false
		return true
	
	# Obtenir les ressources manquantes
	func get_missing_resources() -> Dictionary:
		var missing = {}
		for item_type in requirements.keys():
			var required_qty = requirements[item_type]
			var available_qty = InventoryManager.get_item_count(item_type)
			if available_qty < required_qty:
				missing[item_type] = required_qty - available_qty
		return missing

# Dictionnaire de toutes les recettes (clé = id)
var recipes: Dictionary = {}

# Signal émis quand une recette est craftée
signal recipe_crafted(recipe_id: String, result_item: String, quantity: int)

func _ready():
	_initialize_recipes()

func _initialize_recipes():
	# Catégorie: Outils en bois
	add_recipe(Recipe.new(
		"wooden_axe",  # ID
		"Hache en Bois",  # Nom affiché
		"wooden_axe",  # Item produit
		1,  # Quantité
		{Data.ResourcesName.WOOD: 5},  # Ressources nécessaires
		"tools",  # Catégorie
		0  # Niveau requis
	))
	
	# Catégorie: Outils en fer
	add_recipe(Recipe.new(
		"iron_axe",
		"Hache en Fer",
		"iron_axe",
		1,
		{Data.ResourcesName.WOOD: 2, Data.ResourcesName.IRON: 3},
		"tools",
		1
	))
	
	# Exemples d'autres recettes (à compléter)
	add_recipe(Recipe.new(
		"wooden_pickaxe",
		"Pioche en Bois",
		"wooden_pickaxe",
		1,
		{Data.ResourcesName.WOOD: 6},
		"tools",
		0
	))
	
	add_recipe(Recipe.new(
		"iron_pickaxe",
		"Pioche en Fer",
		"iron_pickaxe",
		1,
		{Data.ResourcesName.WOOD: 2, Data.ResourcesName.IRON: 4},
		"tools",
		1
	))
	
	add_recipe(Recipe.new(
		"iron_sword",
		"Épée en Fer",
		"iron_sword",
		1,
		{Data.ResourcesName.WOOD: 1, Data.ResourcesName.IRON: 3},
		"weapons",
		1
	))
	
	add_recipe(Recipe.new(
		"steel_sword",
		"Épée en Acier",
		"steel_sword",
		1,
		{Data.ResourcesName.WOOD: 1, Data.ResourcesName.STEEL: 3},
		"weapons",
		2
	))
	
	add_recipe(Recipe.new(
		"iron_armor",
		"Armure en Fer",
		"iron_armor",
		1,
		{Data.ResourcesName.IRON: 8},
		"armor",
		2
	))
	
	add_recipe(Recipe.new(
		"wooden_shield",
		"Bouclier en Bois",
		"wooden_shield",
		1,
		{Data.ResourcesName.WOOD: 5, Data.ResourcesName.IRON: 1},
		"armor",
		1
	))
	
	print("RecipeManager initialisé avec ", recipes.size(), " recettes")

# Ajouter une recette au dictionnaire
func add_recipe(recipe: Recipe):
	recipes[recipe.id] = recipe

# Obtenir une recette par son ID
func get_recipe(recipe_id: String) -> Recipe:
	return recipes.get(recipe_id, null)

# Obtenir toutes les recettes
func get_all_recipes() -> Array[Recipe]:
	var all_recipes: Array[Recipe] = []
	for recipe in recipes.values():
		all_recipes.append(recipe)
	return all_recipes

# Obtenir les recettes par catégorie
func get_recipes_by_category(category: String) -> Array[Recipe]:
	var filtered: Array[Recipe] = []
	for recipe in recipes.values():
		if recipe.category == category:
			filtered.append(recipe)
	return filtered

# Obtenir toutes les catégories uniques
func get_categories() -> Array:
	var categories = []
	for recipe in recipes.values():
		if recipe.category not in categories:
			categories.append(recipe.category)
	return categories

# Obtenir les recettes craftables actuellement
func get_craftable_recipes() -> Array[Recipe]:
	var craftable: Array[Recipe] = []
	for recipe in recipes.values():
		if recipe.can_craft():
			craftable.append(recipe)
	return craftable

# Tenter de crafter une recette
func try_craft_recipe(recipe_id: String) -> bool:
	var recipe = get_recipe(recipe_id)
	if recipe == null:
		print("Recette introuvable: ", recipe_id)
		return false
	
	# Vérifier si on peut crafter
	if not recipe.can_craft():
		print("Ressources insuffisantes pour: ", recipe.name)
		var missing = recipe.get_missing_resources()
		print("Manque: ", missing)
		return false
	
	# Retirer les ressources
	for item_type in recipe.requirements.keys():
		var qty = recipe.requirements[item_type]
		InventoryManager.remove_item(item_type, qty)
	
	# Ajouter le résultat
	InventoryManager.add_item(recipe.result_item, recipe.result_quantity)
	
	# Émettre le signal
	emit_signal("recipe_crafted", recipe_id, recipe.result_item, recipe.result_quantity)
	
	print("Craft réussi: ", recipe.name, " x", recipe.result_quantity)
	return true

# Vérifier si une recette est débloquée (basé sur le niveau)
func is_recipe_unlocked(recipe_id: String, player_level: int = 999) -> bool:
	var recipe = get_recipe(recipe_id)
	if recipe == null:
		return false
	return player_level >= recipe.unlock_level

# Obtenir les recettes débloquées pour un niveau donné
func get_unlocked_recipes(player_level: int) -> Array[Recipe]:
	var unlocked: Array[Recipe] = []
	for recipe in recipes.values():
		if player_level >= recipe.unlock_level:
			unlocked.append(recipe)
	return unlocked

# Formater le nom d'un item (utilitaire)
func format_item_name(item_type: String) -> String:
	var names = {
		"wood": "Bois",
		"iron": "Fer",
		"steel": "Acier",
		"stone": "Pierre",
		"gold": "Or",
		"wooden_axe": "Hache en Bois",
		"iron_axe": "Hache en Fer",
		"wooden_pickaxe": "Pioche en Bois",
		"iron_pickaxe": "Pioche en Fer",
		"iron_sword": "Épée en Fer",
		"steel_sword": "Épée en Acier",
		"iron_armor": "Armure en Fer",
		"wooden_shield": "Bouclier en Bois"
	}
	return names.get(item_type, item_type.capitalize())
