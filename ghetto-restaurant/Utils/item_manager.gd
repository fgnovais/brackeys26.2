extends Node

var current_items : Array[Item] = []
var bribe_resource: Item = load("res://Assets/Items/Bribe.tres")
var coupon_resource: Item = load("res://Assets/Items/Coupon.tres")
var skip_resource: Item = load("res://Assets/Items/SkipCustomer.tres")
var lupa_resource: Item = load("res://Assets/Items/Lupa.tres")
var flip_phone_resource: Item = load("res://Assets/Items/Flipphone.tres")
var uber_eats_resource: Item = load("res://Assets/Items/Order.tres")
signal bribe
signal skip_customer
signal coupon
signal lupa
signal flipphone
signal uberEats

func apply(item_name : String) -> void:
	match item_name:
		"Bribe":
			bribe.emit()
		"SkipCustomer":
			skip_customer.emit()
		"Coupon":
			coupon.emit()
		"Lupa":
			lupa.emit()
		"FlipPhone":
			flipphone.emit()
		"Order":
			uberEats.emit()
		
func give_bribe_item():
	current_items.push_back(bribe_resource)
	
func give_coupon_item():
	current_items.push_back(coupon_resource)
	
func give_skip_item():
	current_items.push_back(skip_resource)
	
func give_flipphone_item():
	current_items.push_back(flip_phone_resource)
	
func give_ubereats_item():
	current_items.push_back(uber_eats_resource)
	
func give_lupa_item():
	current_items.push_back(lupa_resource)
