extends TextureRect
class_name DialogBox

@onready var label: Label = $Label

func _ready() -> void:
	modulate = Color.TRANSPARENT
	label.visible_ratio = 0
	
func show_dialog_box(dialog : String):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1).finished
	label.text = dialog
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, 1)
	
func hide_dialog_box():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.7).finished
	await tween.tween_property(label, "visible_ratio", 0, 0.3).finished
