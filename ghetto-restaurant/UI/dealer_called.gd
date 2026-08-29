extends Label

func _ready() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position", position + Vector2(0, -300), 3)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 3)
	await tween.finished
	queue_free()
