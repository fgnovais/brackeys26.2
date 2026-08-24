extends Node

var current_client : Client
#func decrease_odd() -> void: 
	#current_client.

func apply(type : String) -> void:
	match type:
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

#func give_bribe_item():
	#current_items.push_back(bribe_resource)
	#
#func give_coupon_item():
	#current_items.push_back(coupon_resource)
	#
#func give_skip_item():
	#current_items.push_back(skip_resource)
