extends Node2D

@export var float_distance := 20
@export var duration := 0.4

func _ready():
	var tween = create_tween()

	tween.tween_property(
		self,
		"position:y",
		position.y - float_distance,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		duration
	)

	tween.finished.connect(queue_free)
