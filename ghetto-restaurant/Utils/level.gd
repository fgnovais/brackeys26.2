extends Node2D

@onready var client_manager: ClientManager = $ClientManager
var total_money : int = 0
@onready var money: Label = $Money
var bribe_resource: Item = load("res://Assets/Items/Bribe.tres")
var coupon_resource: Item = load("res://Assets/Items/Coupon.tres")
var skip_resource: Item = load("res://Assets/Items/SkipCustomer.tres")


func _ready() -> void:
	client_manager.spawn_aleatorio()
	ItemManager.current_items.push_back(bribe_resource)
	ItemManager.current_items.push_back(skip_resource)
	ItemManager.current_items.push_back(coupon_resource)
	ItemManager.current_items.push_back(bribe_resource)
	
func _on_service_controller_serve_bad() -> void:
	total_money += client_manager.serve_bad_food()
	money.text = str(total_money)
	
func _on_service_controller_serve_good() -> void:
	total_money += client_manager.serve_good_food()
	money.text = str(total_money)
