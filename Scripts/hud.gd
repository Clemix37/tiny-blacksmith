extends CanvasLayer

@onready var delivery_btn: Button = $ButtonContainer/DeliveryBtn
@onready var game_menu_btn: Button = $ButtonContainer/GameMenuBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivery_btn.pressed.connect(_on_delivery_btn_pressed)
	game_menu_btn.pressed.connect(_on_menu_btn_pressed)


func _on_delivery_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Delivery/delivery_scene.tscn")

func _on_menu_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/game_menu.tscn")
