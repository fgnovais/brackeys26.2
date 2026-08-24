extends Node2D

@onready var client_spawner: ClientSpawner = $ClientSpawner
@onready var money: Label = $Money
@onready var day: Label = $Day
@onready var health_points: Label = $HealthPoints
@onready var good_stock: Label = $GoodStock
@onready var bad_stock: Label = $BadStock
@onready var game_over: CanvasLayer = $GameOver

var total_health : int = 5
var total_money : int = 150
var client_queue : Array[Client] = []
var current_client : Client
var current_day : int = 0
var good_stock_amount = 0
var bad_stock_amount = 0

func _ready() -> void:
	game_over.hide()
	next_day() 
	# DEBUG
	ItemManager.give_bribe_item()
	ItemManager.give_bribe_item()
	ItemManager.give_coupon_item()
	ItemManager.give_skip_item()
	
func start_round():
	refresh_labels()
	
	if client_queue.size() > 0:
		var client_scene = client_queue.get(0)
		client_queue.remove_at(0)
		print(current_client.client_info.type)
		add_child(client_scene)
		current_client = client_scene
	else:
		next_day()
	
func _on_service_controller_serve_bad() -> void:
	if bad_stock_amount > 0:
		bad_stock_amount -= 1
		var paid_money = current_client.receive_bad_food()
		if paid_money == -1:
			next_round()
			pass # complain
		else:
			total_money += paid_money
			next_round()
	
func _on_service_controller_serve_good() -> void:
	if good_stock_amount > 0:
		good_stock_amount -= 1
		total_money += current_client.receive_good_food()
		next_round()
		
func next_round()->void:
	get_child(-1).queue_free()
	start_round()

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
		
	start_round()

func buy_good_stock_amount() -> void:
	total_money -= 10
	good_stock_amount += 5
	refresh_labels()
	
func buy_bad_stock_amount() -> void:
	total_money -= 5
	bad_stock_amount += 5
	refresh_labels()

func refresh_labels():
	money.text = str(total_money)
	good_stock.text = str(good_stock_amount)
	bad_stock.text = str(bad_stock_amount)
	day.text = "DAY: " + str(current_day)
	health_points.text = "HEALTH: " + str(total_health)
	
func _on_bell_bell_pressed() -> void:
	total_health -= 1
	if total_health == 0:
		show_game_over()
	next_round()
		
func show_game_over()-> void:
	game_over.show()
	Engine.time_scale = 0 
