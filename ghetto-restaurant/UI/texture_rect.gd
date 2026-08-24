@tool
extends TextureRect
class_name ItemIcon

@onready var label: Label = $Label
@export var item : Item 
signal selected

func _ready() -> void:
	label.text = item.description
	label.hide()
	texture = item.icon
	
func _on_mouse_entered() -> void:
	label.show()
	modulate ='#d2dae2' 

func _on_mouse_exited() -> void:
	label.hide()
	modulate ='#FFFFFF' 
	
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		selected.emit(item)
