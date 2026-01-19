extends Node

const save_location: String = "user://save-game.json"

func save():
	var contents_to_save: Dictionary = {
		"inventory": InventoryManager.get_inventory_save(),
		"money": InventoryManager.money,
	}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save)
	file.close()

func _load():
	if !FileAccess.file_exists(save_location): return
	var file = FileAccess.open(save_location, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	var saved_sata = data.duplicate()
	InventoryManager.money = saved_sata.get("money")
	InventoryManager.load_inventory_saved(saved_sata.get("inventory"))
