@tool
extends TextureRect
class_name ItemIcon

@onready var label: Label = $Label
@export var description : String
@export var item_name : String= ""
signal selected

func _ready() -> void:
	label.text = description
	label.hide()
	
func _on_mouse_entered() -> void:
	label.show()
	modulate ='#d2dae2' 

func _on_mouse_exited() -> void:
	label.hide()
	modulate ='#FFFFFF' 
	
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		selected.emit(item_name)
