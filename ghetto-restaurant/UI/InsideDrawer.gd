extends Control

signal killed

func _on_button_pressed() -> void:
	killed.emit()
	queue_free()

func _on_item_icon_selected(item : Item) -> void:
	item.apply()
