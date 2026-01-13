extends Node

var inventory = {}
var money: int = 0

signal inventory_updated(inventory)
signal money_updated

func add_item(type: String, quantity: int):
	if inventory.has(type):
		inventory[type] += quantity
	else:
		inventory[type] = quantity
	
	print("Item ajouté ", type, " x", quantity)
	inventory_updated.emit(inventory)

func has_item(type: String, quantity: int) -> bool:
	return inventory.has(type) and inventory[type] >= quantity

func remove_item(type: String, quantity: int) -> void:
	if !has_item(type, quantity): return
	inventory[type] -= quantity
	# Supprime la clé si à 0
	if inventory[type] == 0:
		inventory.erase(type)
	inventory_updated.emit(inventory)

func get_item_count(item_type: String):
	return inventory.get(item_type) if has_item(item_type, 0) else 0

func add_money(money_to_add: int) -> void:
	money+= money_to_add
	money_updated.emit()

func remove_money(money_to_remove: int) -> void:
	money -= money_to_remove
	money_updated.emit()

func get_money() -> int:
	return money
