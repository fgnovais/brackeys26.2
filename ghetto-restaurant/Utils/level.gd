extends Node2D

@onready var client_spawner: ClientSpawner = $ClientSpawner
@onready var money: Label = $ServiceController/Money
@onready var day: Label = $ServiceController/Day
@onready var health_points: Label = $HealthPoints
@onready var good_stock: Label = $ServiceController/GoodStock
@onready var bad_stock: Label = $ServiceController/BadStock
@onready var game_over: CanvasLayer = $GameOver
var you_got_stock_scene : PackedScene = load("res://UI/you_got_stock.tscn")
var total_health : int = 5
var total_money : int = 150
var client_queue : Array[Client] = []
var current_client : Client
var current_day : int = 0
var good_stock_amount = 1
var bad_stock_amount = 1

var event_queue : Array[EVENT] = []

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
	next_client()
	next_day() 
	# DEBUG
	ItemManager.give_bribe_item()
	ItemManager.give_bribe_item()
	ItemManager.give_coupon_item()
	ItemManager.give_skip_item()

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
	if event_queue.size() == 0:
		event_queue.push_front(EVENT.SPAWN_CLIENT)
	var event = event_queue.get(0)
	event_queue.remove_at(0)
	
	match event:			
		EVENT.SPAWN_CLIENT:
			next_client()
		EVENT.SPAWN_COP:
			pass
		EVENT.SPAWN_DEALER:
			pass
		EVENT.GIVE_ITEM:
			#var item_name = value
			#match item_name:
				#"Coupon":
					#ItemManager.give_coupon_item()
				#"Bribe":
					#ItemManager.give_bribe_item()
				#"Skip Customer":
					#ItemManager.give_skip_item()
				#"Lupa":
					#ItemManager.give_skip_item()
				#"Flipfone":
					#ItemManager.give_skip_item()
				#"UberEats":
					#ItemManager.give_skip_item()
			pass
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
	if bad_stock_amount > 0:
		bad_stock_amount -= 1
		var paid_money = current_client.receive_bad_food()
		if paid_money == -1:
			event_queue.push_back(EVENT.CLIENT_COMPLAINING)
		else:
			total_money += paid_money
		next_event()
		
func _on_service_controller_serve_good() -> void:
	if good_stock_amount > 0:
		good_stock_amount -= 1
		total_money += current_client.receive_good_food()
		next_event()
		
func next_client()->void:
	var previous_client = get_child(-1)
	if  previous_client is Client:
		previous_client.leave()
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
		
	next_event()

func buy_good_stock_amount() -> void:
	total_money -= 10
	event_queue.push_back(EVENT.STOCK_ARRIVING)
	
func buy_bad_stock_amount() -> void:
	event_queue.push_back(EVENT.SPAWN_DEALER)

func _on_bell_bell_pressed() -> void:
	total_health -= 1
	if total_health == 0:
		show_game_over()
		return
	next_client()
		
func show_game_over()-> void:
	game_over.show()
	Engine.time_scale = 0 
