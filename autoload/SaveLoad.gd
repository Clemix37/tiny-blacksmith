extends Node

# fichiers dispo ici: C:\Users\[USER]\AppData\Roaming\Godot\app_userdata\tiny-blacksmith
const save_location: String = "user://save.json"

func save():
	var contents_to_save: Dictionary = {
		"version": Data.version,
		"inventory": InventoryManager.get_inventory_save(),
		"money": InventoryManager.money,
		"containers": ContainersManager.containers,
	}
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save)
	file.close()

func load():
	if !FileAccess.file_exists(save_location): return
	var file = FileAccess.open(save_location, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	var saved_sata = data.duplicate()
	
	InventoryManager.money = saved_sata.get("money", Data.moneyToStart)
	InventoryManager.load_inventory_saved(saved_sata.get("inventory", {}))
	ContainersManager.containers = saved_sata.get("containers", {})
