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
			item_name = "Recover Ratings"
		ItemManager.Items.SKIP_CUSTOMER:
			item_name = "MOVE IT, BUDDY!"
		ItemManager.Items.COUPON:
			item_name = "Discount x3"
		ItemManager.Items.LUPA:
			item_name = "Investigate"
		ItemManager.Items.FLIP_PHONE:
			item_name = "Call a friend"
		ItemManager.Items.ORDER:
			item_name = "Instant [color=green]meat[/color]"
		ItemManager.Items.CLEAR_DEBT:
			item_name = "Get a loan"
					
func apply() -> void:
	ItemManager.apply(title)
