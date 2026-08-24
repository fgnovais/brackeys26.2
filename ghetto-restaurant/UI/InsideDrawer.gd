extends Control
class_name InsideDrawer

signal killed
@onready var grid_container: GridContainer = $GridContainer

func _on_button_pressed() -> void:
	killed.emit()
	queue_free()

func fill(child : ItemIcon) -> void:
	child.connect("selected", _on_item_icon_selected)
	grid_container.add_child(child)
	
func _on_item_icon_selected(item_node : Node) -> void:
	item_node.item.apply()
	grid_container.remove_child(item_node)
	var pos = ItemManager.current_items.find(item_node.item)
	ItemManager.current_items.remove_at(pos)
