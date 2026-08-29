@tool
extends TextureRect
class_name ItemIcon

@onready var hover: AudioStreamPlayer = $Hover
@onready var description: Label = $Description
@onready var name_label: Label = $Name
@export var item : Item 
signal selected

func _ready() -> void:
	description.text = item.description
	item.get_item_name()
	name_label.text = item.item_name
	description.hide()
	texture = item.icon
	material.set_shader_parameter("onoff",0.2)
	
	if item.title == ItemManager.Items.GOOD_MEAT:
		name_label.text = "3 = 30$"
	elif item.title == ItemManager.Items.BAD_MEAT:
		name_label.text = "? = ?$"
	
	if item.title == ItemManager.Items.GOOD_MEAT and ItemManager.has_coupon:
		name_label.text = "3 = 15$"
		description.text = item.description + ", 50% off!"
		
func _on_mouse_entered() -> void:
	description.show()
	modulate ='#d2dae2' 
	material.set_shader_parameter("onoff",1)
	
	hover.pitch_scale = randf_range(0.7, 1)
	hover.play()
	
func _on_mouse_exited() -> void:
	hover.stop()
	description.hide()
	modulate ='#FFFFFF' 
	material.set_shader_parameter("onoff",0.2)
	
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		selected.emit(self)
