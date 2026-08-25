extends Control

signal stock_accepted

func _on_accept() -> void:
	stock_accepted.emit()
	queue_free()
