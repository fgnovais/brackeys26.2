extends Node

var current_items : Array[Item] = []
var bribe_resource: Item = load("res://Assets/Items/Bribe.tres")
var coupon_resource: Item = load("res://Assets/Items/Coupon.tres")
var skip_resource: Item = load("res://Assets/Items/SkipCustomer.tres")

func apply(item_name : String) -> void:
	match item_name:
		"Bribe":
			bribe()
		"Skip Customer":
			skip_customer()
		"Coupon":
			coupon()
		
func bribe() -> void:
	print("get bribed bitch")
	
func skip_customer() -> void:
	print("get skipped bitch")

func coupon() -> void:
	print("gimme that")

func give_bribe_item():
	current_items.push_back(bribe_resource)
	
func give_coupon_item():
	current_items.push_back(coupon_resource)
	
func give_skip_item():
	current_items.push_back(skip_resource)
