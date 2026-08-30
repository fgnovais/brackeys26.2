extends Node

var current_items : Array[Item] = []
var bribe_resource: Item = load("res://Assets/Items/Bribe.tres")
var coupon_resource: Item = load("res://Assets/Items/Coupon.tres")
var skip_resource: Item = load("res://Assets/Items/SkipCustomer.tres")
var lupa_resource: Item = load("res://Assets/Items/Lupa.tres")
var flip_phone_resource: Item = load("res://Assets/Items/Flipphone.tres")
var order_resource: Item = load("res://Assets/Items/Order.tres")
var clear_debt_resource: Item = load("res://Assets/Items/ClearDebt.tres")
var get_item: PackedScene = load("res://UI/get_item.tscn")
var has_coupon: bool = false

signal bribe
signal skip_customer
signal coupon
signal lupa
signal flipphone
signal uberEats
signal clear_debt
signal hide_dialogs
signal show_dialogs

enum Items {
	BRIBE,
	SKIP_CUSTOMER,
	COUPON,
	LUPA,
	FLIP_PHONE,
	ORDER,
	CLEAR_DEBT,
	GOOD_MEAT,
	BAD_MEAT
}

func apply(item_name : Items) -> void:
	match item_name:
		Items.BRIBE:
			bribe.emit()
		Items.SKIP_CUSTOMER:
			skip_customer.emit()
		Items.COUPON:
			coupon.emit()
		Items.LUPA:
			lupa.emit()
		Items.FLIP_PHONE:
			flipphone.emit()
		Items.ORDER:
			uberEats.emit()
		Items.CLEAR_DEBT:
			clear_debt.emit()
		
func give_item(item : Items):
	var inst = get_item.instantiate()
	add_child(inst)
	inst.connect("show_dialogs", _show_dialogs)
	
	match item:
		Items.BRIBE:
			inst.item_icon.item = bribe_resource
		Items.SKIP_CUSTOMER:
			inst.item_icon.item = skip_resource
		Items.COUPON:
			inst.item_icon.item = coupon_resource
		Items.LUPA:
			inst.item_icon.item = lupa_resource
		Items.FLIP_PHONE:
			inst.item_icon.item = flip_phone_resource
		Items.ORDER:
			inst.item_icon.item = order_resource
		Items.CLEAR_DEBT:
			inst.item_icon.item = clear_debt_resource
			
	inst.item_icon._ready()

func give_random_item(amount: int = 1):
	hide_dialogs.emit()
	
	for i in amount:
		var range = randi_range(0, 100)
		if range <= 35:
			give_item(Items.LUPA)
		elif range > 35 and range <= 45:
			give_item(Items.SKIP_CUSTOMER)
		elif range > 45 and range <= 50:
			give_item(Items.CLEAR_DEBT)
		elif range > 50 and range <= 65:
			give_item(Items.COUPON)
		elif range > 65 and range <= 85:
			give_item(Items.BRIBE)
		elif range > 85 and range <= 93:
			give_item(Items.FLIP_PHONE)
		elif range > 95 and range <= 100:
			give_item(Items.ORDER)
	
func _show_dialogs():
	if get_child_count() == 1:
		show_dialogs.emit()
