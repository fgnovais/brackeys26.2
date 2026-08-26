extends Control

signal serve_bad
signal serve_good
var can_buy_good : bool = true
var can_buy_bad : bool = true

func _on_good_pressed() -> void:
	if can_buy_good:
		serve_good.emit()
		can_buy_good = false
		await get_tree().create_timer(2).timeout
		can_buy_good = true

func _on_bad_pressed() -> void:
	if can_buy_bad:
		serve_bad.emit()
		can_buy_bad = false
		await get_tree().create_timer(2).timeout
		can_buy_bad = true
