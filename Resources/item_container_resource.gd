extends Resource
class_name ItemContainerResource

@export var item_name: String = "Item name"
@export var quantity: int = 1500
@export var give_rate: float = 0.5 # Donne 2 items / s

func remove_quantity(nb_to_remove: int) -> void:
	quantity -= nb_to_remove
