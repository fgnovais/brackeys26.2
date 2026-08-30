extends Control

signal buy_good
signal buy_bad
signal close
@onready var good_name: RichTextLabel = $ItemIcon/Name

func _on_buy_good_stock_pressed(_a) -> void:
	buy_good.emit()
	queue_free()

func _on_buy_bad_stock_pressed(_a) -> void:
	buy_bad.emit()
	queue_free()

func _on_button_pressed() -> void:
	close.emit()
	queue_free()
