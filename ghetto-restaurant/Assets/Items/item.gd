extends Resource
class_name Item

@export var description: String
@export var title: String
@export var icon : Texture2D 

func apply() -> void:
	ItemManager.apply(title)
