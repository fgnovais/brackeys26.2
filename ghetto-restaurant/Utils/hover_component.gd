extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
var parent : Node
signal selected

func _ready() -> void:
	parent = get_parent()
	
func _on_area_2d_mouse_entered() -> void:
	selected.emit(true)	

func _on_area_2d_mouse_exited() -> void:
	selected.emit(false)
