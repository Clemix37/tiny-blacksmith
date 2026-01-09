extends Node2D

@onready var back_btn: Button = $CanvasLayer/BackBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_btn.pressed.connect(_on_back_btn_pressed)

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
