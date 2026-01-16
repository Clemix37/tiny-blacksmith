extends CanvasLayer

@onready var money_label: Label = $Control/MoneyPanel/MoneyLabel
@onready var quit_game_btn: Button = $Control/QuitGameBtn
@onready var delivery_btn: Button = $Control/DeliveryBtn
@onready var menu_btn: Button = $Control/MenuBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivery_btn.pressed.connect(_on_delivery_btn_pressed)
	menu_btn.pressed.connect(_on_menu_btn_pressed)
	quit_game_btn.pressed.connect(_quit_game)
	if InventoryManager.has_signal("money_updated"):
		InventoryManager.money_updated.connect(_update_money_label)
	_update_money_label()


func _on_delivery_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Delivery/delivery_scene.tscn")

func _on_menu_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/game_menu.tscn")

func _update_money_label():
	money_label.text = str(InventoryManager.get_money()) + "$"

func _quit_game():
	get_tree().quit()
