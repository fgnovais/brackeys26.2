extends Resource
class_name Item

@export var description: String
@export var title: ItemManager.Items
@export var icon : Texture2D 

func apply() -> void:
	ItemManager.apply(title)
