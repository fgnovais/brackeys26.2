extends Control

var level_scene : PackedScene = load("res://UI/level.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)
