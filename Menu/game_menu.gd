extends Node2D

@onready var play_btn: Button = $UI/HBoxContainer/MarginContainer/VBoxContainer/PlayBtn
@onready var options_btn: Button = $UI/HBoxContainer/MarginContainer/VBoxContainer/OptionsBtn
@onready var quit_game_btn: Button = $UI/HBoxContainer/MarginContainer/VBoxContainer/QuitGameBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	quit_game_btn.pressed.connect(_quit_game)

func _on_play_pressed():
	SaveLoad._load()
	get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")

func _quit_game():
	get_tree().quit()
