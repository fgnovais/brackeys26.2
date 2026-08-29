extends Control

signal buy_good
signal buy_bad
@onready var good_name: Label = $ItemIcon/Name

func _on_buy_good_stock_pressed(_a) -> void:
	buy_good.emit()
	queue_free()

func _on_buy_bad_stock_pressed(_a) -> void:
	buy_bad.emit()
	queue_free()
