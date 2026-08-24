extends Node

var current_items : Array[Item] = []

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
