extends Control

signal give_meat
@onready var item_icon: ItemIcon = $ItemIcon

func _ready() -> void:
	item_icon.texture = item_icon.item.icon
	
func _on_item_icon_selected(item: ItemIcon) -> void:
	#if item.item.title == "Meat" || item.item.title == "Bad Meat":
		#give_meat.emit(item.item.title)
	#else:
	ItemManager.current_items.push_back(item.item)
	queue_free()
