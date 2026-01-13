extends Resource
class_name ItemContainerResource

@export var quantity: int = 1500
@export var give_rate: float = 0.5 # Donne 2 items / s
@export var game_resource: GameResource = null

func remove_quantity(nb_to_remove: int) -> void:
	quantity -= nb_to_remove
