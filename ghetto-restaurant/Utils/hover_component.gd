extends Node2D

var parent : Node2D
signal selected
signal pressed
var is_selected: bool = false
const HIGHLIGHT = preload("uid://d25a46rib4y4v")

func _ready() -> void:
	parent = get_parent()
	parent.material = ShaderMaterial.new()
	
	var override_material = ShaderMaterial.new()
	override_material.shader = HIGHLIGHT
	parent.material = override_material
	parent.material.set_shader_parameter("onoff",0)
	parent.material.set_shader_parameter("line_thickness",5)
	parent.material.set_shader_parameter("line_color", Color.WHITE)
	
func _on_area_2d_mouse_entered() -> void:
	selected.emit(true)	
	is_selected = true
	parent.modulate ='#d2dae2' 
	parent.material.set_shader_parameter("onoff",1)
	
func _on_area_2d_mouse_exited() -> void:
	selected.emit(false)
	is_selected = false
	parent.modulate = '#FFFFFF'
	parent.material.set_shader_parameter("onoff",0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		if is_selected:
			pressed.emit()
