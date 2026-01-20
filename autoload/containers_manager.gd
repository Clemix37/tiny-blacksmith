extends Node

var ContainersIds = ["wood_container", "steel_container", "copper_container", "iron_container", "coal_container"]
var containers = {}

func _ready() -> void:
	create_empty_containers()

func create_empty_containers() -> void:
	for id_container in ContainersIds:
		containers[id_container] = 0

func get_container_quantity(id_container: String) -> int:
	return containers[id_container]

func remove_quantity(id_container: String, nb_to_remove: int) -> void:
	if !containers.has(id_container): return
	containers[id_container] -= nb_to_remove

func add_quantity(id_container: String, nb_to_add: int) -> void:
	if !containers.has(id_container): return
	containers[id_container] += nb_to_add
