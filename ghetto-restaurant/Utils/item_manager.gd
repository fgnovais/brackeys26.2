extends Node

var current_items : Array[Item] = []
var bribe_resource: Item = load("res://Assets/Items/Bribe.tres")
var coupon_resource: Item = load("res://Assets/Items/Coupon.tres")
var skip_resource: Item = load("res://Assets/Items/SkipCustomer.tres")
var lupa_resource: Item = load("res://Assets/Items/Lupa.tres")
var flip_phone_resource: Item = load("res://Assets/Items/Flipphone.tres")
var order_resource: Item = load("res://Assets/Items/Order.tres")
var get_item: PackedScene = load("res://UI/get_item.tscn")

signal bribe
signal skip_customer
signal coupon
signal lupa
signal flipphone
signal uberEats
signal hide_dialogs
signal show_dialogs

enum Items {
	BRIBE,
	SKIP_CUSTOMER,
	COUPON,
	LUPA,
	FLIP_PHONE,
	ORDER,
	MEAT
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
			
	inst.item_icon._ready()

func give_random_item(amount: int = 1):
	hide_dialogs.emit()
	for i in amount:
		give_item(randi_range(0, 5))
	
func _show_dialogs():
	if get_child_count() == 1:
		show_dialogs.emit()
