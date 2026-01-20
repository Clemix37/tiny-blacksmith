extends CanvasLayer

@onready var money_label: Label = $Control/MoneyPanel/MoneyLabel
@onready var delivery_btn: Button = $Control/DeliveryBtn
@onready var menu_btn: Button = $Control/MenuBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivery_btn.pressed.connect(_on_delivery_btn_pressed)
	menu_btn.pressed.connect(_on_menu_btn_pressed)
	if InventoryManager.has_signal("money_updated"):
		InventoryManager.money_updated.connect(_update_money_label)
	_update_money_label()


func _on_delivery_btn_pressed():
	get_tree().change_scene_to_file("res://Delivery/delivery.tscn")

func _on_menu_btn_pressed():
	SaveLoad.save()
	get_tree().change_scene_to_file("res://Menu/game_menu.tscn")

func _update_money_label():
	money_label.text = str(InventoryManager.get_money()) + "$"
