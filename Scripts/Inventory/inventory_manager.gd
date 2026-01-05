extends Node

var inventory = {}

signal inventory_updated(inventory)

func add_item(type: String, quantity: int):
	if inventory.has(type):
		inventory[type] += quantity
	else:
		inventory[type] = quantity
	
	print("Item ajouté ", type, " x", quantity)
	emit_signal("inventory_updated", inventory)

func has_item(type: String, quantity: int) -> bool:
	return inventory.has(type) and inventory[type] >= quantity

func remove_item(type: String, quantity: int) -> void:
	if !has_item(type, quantity): return
	inventory[type] -= quantity
	# Supprime la clé si à 0
	if inventory[type] == 0:
		inventory.erase(type)
	emit_signal("inventory_updated", inventory)
