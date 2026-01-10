extends Node2D

@onready var play_btn: Button = $UI/HBoxContainer/VBoxContainer/PlayBtn
@onready var options_btn: Button = $UI/HBoxContainer/VBoxContainer/OptionsBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/main.tscn")
