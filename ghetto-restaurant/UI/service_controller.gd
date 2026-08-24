extends Control

signal serve_bad
signal serve_good

func _on_good_pressed() -> void:
	serve_good.emit()

func _on_bad_pressed() -> void:
	serve_bad.emit()
