extends Node

## Clé = id, Valeur = InventoryItem
var inventory = {}
var money: int = 0

signal inventory_updated(inventory)
signal money_updated

func add_item(item_id: String, item_name: String, quantity: int = 1) -> void:
	if inventory.has(item_id):
		inventory[item_id].quantity += quantity
	else:
		inventory[item_id] = InventoryItem.new(item_id, item_name, quantity)
	inventory_updated.emit(inventory)

func has_item(item_id: String, quantity: int = 1) -> bool:
	return inventory.has(item_id) and inventory.get(item_id).quantity >= quantity

func remove_item(item_id: String, quantity: int = 1) -> void:
	if !has_item(item_id, quantity): return
	inventory[item_id].quantity -= quantity
	# Supprime la clé si à 0
	if inventory[item_id].quantity == 0:
		inventory.erase(item_id)
	inventory_updated.emit(inventory)

func get_item_count(item_id: String):
	return inventory.get(item_id).quantity if has_item(item_id, 0) else 0

func get_inventory_save():
	var inv_to_save: Dictionary = {}
	for id_item in inventory.keys():
		inv_to_save[id_item] = get_item_count(id_item)
	return inv_to_save

# saved_inventory contains ids of resource / ForgeItem and as values the quantity
# will get based on id if the item is a resource or a forge item (recipe)
func load_inventory_saved(saved_inventory: Dictionary):
	for id_item in saved_inventory.keys():
		var contains_recipe: bool = RecipeManager.recipes.has(id_item)
		if contains_recipe:
			add_item(id_item, RecipeManager.recipes.get(id_item).name, saved_inventory[id_item])
		else:
			add_item(id_item, Data.ResourcesNameArray[Data.ResourcesIdsArray.find(id_item)], saved_inventory[id_item])

func add_money(money_to_add: int) -> void:
	money += money_to_add
	money_updated.emit()

func remove_money(money_to_remove: int) -> void:
	money -= money_to_remove
	money_updated.emit()

func get_money() -> int:
	return money

class InventoryItem:
	var id: String
	var name: String
	var quantity: int
	func _init(item_id: String, item_name: String, item_quantity: int = 1):
		id = item_id
		name = item_name
		quantity = item_quantity
