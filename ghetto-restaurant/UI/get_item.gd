extends Control

signal give_meat
signal show_dialogs
@onready var item_icon: ItemIcon = $ItemIcon

func _ready() -> void:
	item_icon.texture = item_icon.item.icon
	if item_icon.item.title == ItemManager.Items.GOOD_MEAT or item_icon.item.title == ItemManager.Items.BAD_MEAT:
		item_icon.name_label.text = item_icon.item.description
		item_icon.description.modulate = Color.TRANSPARENT
		
func _on_item_icon_selected(item: ItemIcon) -> void:
	if item.item.title == ItemManager.Items.GOOD_MEAT or item.item.title == ItemManager.Items.BAD_MEAT:
		give_meat.emit()
	else:
		ItemManager.current_items.push_back(item.item)
	show_dialogs.emit()
	queue_free()
	
