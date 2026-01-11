extends Node

@onready var game_menu_btn: Button = $MarginContainer/VBoxContainer/ButtonContainer/VBoxContainer/HBoxContainer/GameMenuBtn
@onready var delivery_btn: Button = $MarginContainer/VBoxContainer/ButtonContainer/VBoxContainer/HBoxContainer/DeliveryBtn
@onready var money_label: Label = $MarginContainer/VBoxContainer/ButtonContainer/InventoryContainer/HBoxContainer/MoneyLabel
@onready var quit_btn: Button = $MarginContainer/VBoxContainer/ButtonContainer/VBoxContainer/HBoxContainer/QuitBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivery_btn.pressed.connect(_on_delivery_btn_pressed)
	game_menu_btn.pressed.connect(_on_menu_btn_pressed)
	quit_btn.pressed.connect(_quit_game)
	if InventoryManager.has_signal("money_updated"):
		InventoryManager.money_updated.connect(_update_money_label)


func _on_delivery_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Delivery/delivery_scene.tscn")

func _on_menu_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/game_menu.tscn")

func _update_money_label():
	money_label.text = str(InventoryManager.money) + "$"

func _quit_game():
	get_tree().quit()
