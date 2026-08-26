extends Node2D
class_name Level

@onready var client_spawner: ClientSpawner = $ClientSpawner
@onready var money: Label = $ServiceController/Money
@onready var day: Label = $ServiceController/Day
@onready var health_points: Label = $HealthPoints
@onready var good_stock: Label = $ServiceController/GoodStock
@onready var bad_stock: Label = $ServiceController/BadStock
@onready var game_over: CanvasLayer = $GameOver
@onready var preview: Preview = $Preview
var you_got_stock_scene : PackedScene = load("res://UI/you_got_stock.tscn")
var total_health : int = 5
var total_money : int = 150
var client_queue : Array[Client] = []
var current_client : Client
var current_day : int = 0
var good_stock_amount = 1
var bad_stock_amount = 1

var event_queue : Array[EVENT] = []
var coupon_is_active: bool = false

## EVENT SYSTEM
enum EVENT {
	SPAWN_COP,
	SPAWN_DEALER,
	SPAWN_CLIENT,
	GIVE_ITEM,
	STOCK_ARRIVING,
	CHEF_COMPLAINING,
	CLIENT_COMPLAINING
}

func _ready() -> void:
	game_over.hide()
	next_day() 
	next_client()
	# DEBUG
	ItemManager.give_bribe_item()
	ItemManager.give_flipphone_item()
	ItemManager.give_coupon_item()
	ItemManager.give_skip_item()
	ItemManager.give_ubereats_item()
	ItemManager.give_lupa_item()
	ItemManager.connect("uberEats", uberEats)
	ItemManager.connect("bribe", bribe)
	ItemManager.connect("skip_customer", skip_customer)
	ItemManager.connect("coupon", coupon)
	ItemManager.connect("lupa", lupa)
	ItemManager.connect("flipphone", flipphone)

func uberEats():
	var stock = you_got_stock_scene.instantiate()
	stock.connect("stock_accepted", increase_good_stock)
	add_child(stock)
	
func bribe():
	print("test")

func skip_customer():
	current_client.leave()
	next_event()
	
func coupon():
	coupon_is_active = true

func lupa():
	current_client.percentage.show()

func flipphone():
	print("flipphone")
	
#refresh labels every 0.3 seconds
var delta_add : float = 0.3
func _process(delta: float) -> void:
	delta_add += delta
	if delta_add > 0.2:
		delta_add = 0
		refresh_labels()

func refresh_labels():
	money.text = str(total_money)
	good_stock.text = str(good_stock_amount)
	bad_stock.text = str(bad_stock_amount)
	day.text = "DAY: " + str(current_day)
	health_points.text = "HEALTH: " + str(total_health)
			
func next_event():
	preview.next_queue = event_queue.slice(0,3)
	preview.update_textures()
	if event_queue.size() == 0:
		event_queue.push_front(EVENT.SPAWN_CLIENT)
	var event = event_queue.get(0)
	event_queue.remove_at(0)
	
	match event:			
		EVENT.SPAWN_CLIENT:
			await next_client()
		EVENT.SPAWN_COP:
			await next_client()
		EVENT.SPAWN_DEALER:
			await next_client()
		EVENT.GIVE_ITEM:
			var item_name = "Coupon"
			match item_name:
				"Coupon":
					ItemManager.give_coupon_item()
				"Bribe":
					ItemManager.give_bribe_item()
				"SkipCustomer":
					ItemManager.give_skip_item()
				"Lupa":
					ItemManager.give_lupa_item()
				"Flipphone":
					ItemManager.give_flipphone_item()
				"UberEats":
					ItemManager.give_ubereats_item()
		EVENT.STOCK_ARRIVING:
			var stock = you_got_stock_scene.instantiate()
			stock.connect("stock_accepted", increase_good_stock)
			add_child(stock)
			#good_stock_amount += 3
		EVENT.CHEF_COMPLAINING:
			pass
		EVENT.CLIENT_COMPLAINING:
			pass

func increase_good_stock()-> void:
	good_stock_amount += 3
	next_event()
	
func _on_service_controller_serve_bad() -> void:
	if bad_stock_amount > 0 and current_client != null:
		bad_stock_amount -= 1
		var paid_money = current_client.receive_bad_food()
		current_client.leave()
		if paid_money == -1:
			event_queue.push_back(EVENT.CLIENT_COMPLAINING)
		else:
			total_money += paid_money
		next_event()
		
func _on_service_controller_serve_good() -> void:
	if good_stock_amount > 0 and current_client != null:
		good_stock_amount -= 1
		total_money += current_client.receive_good_food()
		current_client.leave()
		next_event()
		
func next_client()->void:
	await get_tree().create_timer(1.5).timeout
	if client_queue.size() > 0:
		var client_scene = client_queue.get(0)
		client_queue.remove_at(0)
		add_child(client_scene)
		current_client = client_scene
	else:
		next_day()

func next_day() -> void:
	current_day += 1
	var client_count = 4
	match current_day:
		1:
			client_count = 6
		2:
			client_count = 8
		3:
			client_count = 10
		4:
			client_count = 15
		_:
			client_count = 500
			
	for i in client_count:
		client_queue.push_back(client_spawner.spawn_client())

func buy_good_stock_amount() -> void:
	if coupon_is_active && total_money >= 5:
		total_money -= 5
		coupon_is_active = false
	elif total_money >= 10:
		total_money -= 10
	else:
		print("You got no money!")
		
	add_to_queue_in(EVENT.STOCK_ARRIVING, 2)
	
func buy_bad_stock_amount() -> void:
	add_to_queue_in(EVENT.SPAWN_DEALER, 5)

func _on_bell_bell_pressed() -> void:
	total_health -= 1
	if total_health == 0:
		show_game_over()
		return
	if current_client != null:
		current_client.leave()
	next_event()

func show_game_over()-> void:
	game_over.show()
	Engine.time_scale = 0 

func add_to_queue_in(event: EVENT, pos: int):
	for i in pos:
		if i+1 == pos:
			event_queue.insert(pos-1, event)
		elif event_queue.size() <= i:
			event_queue.push_back(EVENT.SPAWN_CLIENT)
