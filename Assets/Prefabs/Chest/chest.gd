extends Node2D

@onready var chest_animation: AnimatedSprite2D = $ChestAnimation

func open():
	chest_animation.play("chest_opening")

func close():
	chest_animation.play("chest_closing")
