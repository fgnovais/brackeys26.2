extends Resource
class_name Item

@export var description: String
@export var title: ItemManager.Items
@export var icon : Texture2D 
var item_name

func _init() -> void:
	get_item_name()

func get_item_name():
	match title:
		ItemManager.Items.BRIBE:
			item_name = "Let's forget this"
		ItemManager.Items.SKIP_CUSTOMER:
			item_name = "MOVE IT, BUDDY"
		ItemManager.Items.COUPON:
			item_name = "Discount"
		ItemManager.Items.LUPA:
			item_name = "Investigate"
		ItemManager.Items.FLIP_PHONE:
			item_name = "Call a friend"
		ItemManager.Items.ORDER:
			item_name = "Free groceries"
					
func apply() -> void:
	ItemManager.apply(title)
