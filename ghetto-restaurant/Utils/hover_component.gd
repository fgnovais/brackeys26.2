extends Node2D

var parent : Node
signal selected
signal pressed
var is_selected: bool = false
func _ready() -> void:
	parent = get_parent()
	
func _on_area_2d_mouse_entered() -> void:
	selected.emit(true)	
	is_selected = true
	get_parent().modulate ='#d2dae2' 
	
func _on_area_2d_mouse_exited() -> void:
	selected.emit(false)
	is_selected = false
	get_parent().modulate = '#FFFFFF'

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		if is_selected:
			pressed.emit()
