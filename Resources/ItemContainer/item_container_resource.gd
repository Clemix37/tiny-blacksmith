extends Resource
class_name ItemContainerResource

@export var id_container: String = ""
@export var give_rate: float = 0.5 # Donne 2 items / s
@export var game_resource: GameResource = null

func remove_quantity(nb_to_remove: int) -> void:
	ContainersManager.remove_quantity(id_container, nb_to_remove)
