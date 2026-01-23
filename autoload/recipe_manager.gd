extends Node

# Classe pour définir une recette
class Recipe extends GameResource:
	var result_item: String  # Item produit
	var result_quantity: int  # Quantité produite
	var requirements: Dictionary  # {item_id: quantity}
	var reward: int # Argent de récompense
	
	func _init(p_id: String, p_name: String, p_result: String, p_quantity: int, p_requirements: Dictionary, p_reward: int):
		id = p_id
		name = p_name
		result_item = p_result
		result_quantity = p_quantity
		requirements = p_requirements
		reward = p_reward
	
	# Vérifier si le joueur a les ressources nécessaires
	func can_craft() -> bool:
		for item_index in requirements.keys():
			var item_type: String = Data.ResourcesIdsArray[item_index]
			var required_qty = requirements[item_index]
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
		"Wooden Axe",  # Nom affiché
		"wooden_axe",  # Item produit
		1,  # Quantité
		{Data.ResourcesName.WOOD: 5},  # Ressources nécessaires
		8,
	))
	
	# Catégorie: Outils en fer
	add_recipe(Recipe.new(
		"iron_axe",
		"Iron Axe",
		"iron_axe",
		1,
		{Data.ResourcesName.WOOD: 2, Data.ResourcesName.IRON: 3},
		28,
	))
	
	# Exemples d'autres recettes (à compléter)
	add_recipe(Recipe.new(
		"wooden_pickaxe",
		"Woode Pickaxe",
		"wooden_pickaxe",
		1,
		{Data.ResourcesName.WOOD: 6},
		7,
	))
	
	add_recipe(Recipe.new(
		"iron_pickaxe",
		"Iron Pickaxe",
		"iron_pickaxe",
		1,
		{Data.ResourcesName.WOOD: 2, Data.ResourcesName.IRON: 4},
		26,
	))
	
	add_recipe(Recipe.new(
		"iron_sword",
		"Iron Sword",
		"iron_sword",
		1,
		{Data.ResourcesName.WOOD: 1, Data.ResourcesName.IRON: 3},
		40,
	))
	
	add_recipe(Recipe.new(
		"steel_sword",
		"Steel Sword",
		"steel_sword",
		1,
		{Data.ResourcesName.WOOD: 1, Data.ResourcesName.STEEL: 3},
		70,
	))
	
	add_recipe(Recipe.new(
		"iron_armor",
		"Iron Armor",
		"iron_armor",
		1,
		{Data.ResourcesName.IRON: 8},
		90,
	))
	
	add_recipe(Recipe.new(
		"wooden_shield",
		"Wooden Shield",
		"wooden_shield",
		1,
		{Data.ResourcesName.WOOD: 5, Data.ResourcesName.IRON: 1},
		10,
	))
	

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

## Retourne un recette aléatoire
func get_random_recipe() -> Recipe:
	var all_recipes: Array[Recipe] = get_all_recipes()
	return all_recipes.pick_random()
