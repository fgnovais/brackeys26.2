extends Node2D
class_name Level

@onready var client_spawner: ClientSpawner = $ClientSpawner
@onready var money: Label = $ServiceController/Money
@onready var day: Label = $ServiceController/Day
@onready var health_points: AnimatedSprite2D = $HealthPoints
@onready var good_stock: Label = $PlayerBox/GiveGoodBurger/GoodStock
@onready var bad_stock: Label = $PlayerBox/GiveBadBurger/BadStock
@onready var take_deal: Button = $ServiceController/TakeDeal
@onready var cancel_deal: Button = $ServiceController/CancelDeal
@onready var serve_good_button: Button = $PlayerBox/GiveGoodBurger
@onready var serve_bad_button: Button = $PlayerBox/GiveBadBurger
@onready var pay_fine: Button = $ServiceController/PayFine
@onready var game_over: CanvasLayer = $GameOver
@onready var preview: Preview = $Preview
@onready var player_box: DialogBox = $PlayerBox
@onready var deal_quantity : int = 0
@onready var deal_price : int = 0
@onready var clients_asserter_scene: PackedScene = load("res://Utils/clients_asserter.tscn")
@onready var animation_player: AnimationPlayer = $HealthPoints/AnimationPlayer
@onready var service_controller: Control = $ServiceController
@onready var phone: Sprite2D = $Phone
@onready var register_player: AnimationPlayer = $Background/L1/Register/RegisterPlayer
@onready var register_audio: AudioStreamPlayer = $Background/L1/Register/RegisterAudio
@onready var serve: AudioStreamPlayer = $Serve
@onready var coupons: HBoxContainer = $Coupons
const BAD_MEAT_RESOURCE = preload("uid://phng332imj5i")
const GOOD_MEAT_RESOURCE = preload("uid://cffxeehgwieho")
const CASH_REGISTER_2 = preload("uid://dtrfksvgsu1wx")
const COINS_2 = preload("uid://dl5j1xdx1ne1e")
var dealer_called : PackedScene = load("res://UI/dealer_called.tscn")

var you_got_stock_scene : PackedScene = load("res://UI/get_item.tscn")
var total_health : int = 5
var total_money : int = 30
var client_queue : Array[Client] = []
var current_client : Client
var current_day : int = 0
var good_stock_amount = 1
var bad_stock_amount = 1

var bad_stock_purchases : int = 0
var cop_chance_max : float = 0.3
var cop_chance_step : float = 0.15
var fine_amount : int = 30

var is_processing_action : bool = false
var is_spawning : bool = false

var event_queue : Array[EVENT] = []
var coupon_count: int = 0
var client_infos: Array[Client_Info] = []
const GOOD_BURGER_COST = 50

## EVENT SYSTEM
enum EVENT {
	SPAWN_DEALER,
	SPAWN_CLIENT,
	GIVE_ITEM,
	STOCK_ARRIVING,
	CHEF_COMPLAINING,
	CLIENT_COMPLAINING
}
@onready var ambiance: Node = $Ambiance

func spawn_client_asserter():
	var clients_asserter = clients_asserter_scene.instantiate()
	clients_asserter.connect("start_level", start_level)
	add_child(clients_asserter)
	await get_tree().create_timer(1).timeout
	client_infos = await clients_asserter.populate_day(current_day)

func start_level():
	is_first_item_clear = true
	ItemManager.give_random_item(5)
	ambiance.start()
	# DEBUG
	
func _ready() -> void:
	for i in 3:
			coupons.get_child(i).hide()
	Engine.time_scale = 4
	ItemManager.connect("uberEats", uberEats)
	ItemManager.connect("bribe", bribe)
	ItemManager.connect("skip_customer", skip_customer)
	ItemManager.connect("coupon", coupon)
	ItemManager.connect("lupa", lupa)
	ItemManager.connect("flipphone", flipphone)
	ItemManager.connect("hide_dialogs", _on_phone_hide_dialog)
	ItemManager.connect("show_dialogs", first_item_clear)
	
	game_over.hide()
	serve_good_button.hide()
	serve_bad_button.hide()
	pay_fine.hide()
	
	# start the day
	next_day()

func uberEats():
	var stock = you_got_stock_scene.instantiate()
	_on_phone_hide_dialog()
	stock.connect("give_meat", increase_stock_uber_eats)
	add_child(stock)
	stock.item_icon.item = GOOD_MEAT_RESOURCE
	stock.item_icon._ready()
	stock._ready()
	
func skip_customer():
	if is_processing_action:
		return
	is_processing_action = true
	
	await hide_dialogs_and_buttons()
	if current_client != null and is_instance_valid(current_client):
		current_client.leave()
		current_client = null
	next_event()
	is_processing_action = false
	
func coupon():
	coupon_count = 3
	for i in coupon_count:
		coupons.get_child(i).show()
	ItemManager.has_coupon = true

func bribe():
	if is_processing_action:
		return
	if current_client == null or not is_instance_valid(current_client):
		return
	
	if current_client.client_info.type == Client_Info.Type.ASAE:
		is_processing_action = true
		var max_health : int = 5
		total_health = max_health
		animation_player.play("gain_hp")
		current_client.leave()
		current_client = null
		next_event()
		is_processing_action = false
		print("You rat ahrr... you can go!")
		print(total_health)
	elif current_client.client_info.type == Client_Info.Type.FAKE_ASAE:
		print("Better Luck next time")
	else:
		print("Not Inspector, you missed your chance")

func flipphone():
	if is_processing_action:
		return
	if current_client == null or not is_instance_valid(current_client):
		return
	
	if current_client.client_info.type == Client_Info.Type.COP:
		is_processing_action = true
		current_client.leave()
		current_client = null
		next_event()
		is_processing_action = false
		print("I'm actually leaving, have a good day")
	elif current_client.client_info.type == Client_Info.Type.FAKE_COP:
		print("Not currently working, you are a lucky man")
	else:
		print("Not COP, you missed your chance")

func lupa():
	if current_client == null or not is_instance_valid(current_client):
		return
	current_client.type.show()
		
#refresh labels every 0.3 seconds
var delta_add : float = 0.3
func _process(delta: float) -> void:
	delta_add += delta
	if delta_add > 0.2:
		delta_add = 0
		refresh_labels()

func refresh_labels():
	money.text = str(total_money) + "$"
	good_stock.text = str(good_stock_amount)
	bad_stock.text = str(bad_stock_amount)
	day.text = "DAY: " + str(current_day)
	health_points.frame = (total_health*2) -1
			
func next_event():
	phone.enable()
	preview.next_queue = event_queue.slice(0,3)
	preview.update_textures()
	if event_queue.size() == 0:
		event_queue.push_front(EVENT.SPAWN_CLIENT)
	var event = event_queue.get(0)
	event_queue.remove_at(0)
	
	match event:			
		EVENT.SPAWN_CLIENT:
			await next_client()
		EVENT.SPAWN_DEALER:
			if client_queue.size() > 0:
				var cop_chance = min(cop_chance_max, bad_stock_purchases * cop_chance_step)
				if randf() < cop_chance:
					client_queue[0].client_info.request_cop()
				else:
					client_queue[0].client_info.dealer_is_requested = true
					client_queue[0].client_info.get_type()
					client_queue[0].client_info.update_texture_to_type()
					client_queue[0].client_info.update_dialog_to_type()
			await next_client()
			player_box.hide()
			serve_good_button.hide()
			serve_bad_button.hide()
			good_stock.hide()
			bad_stock.hide()
	
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
			stock.connect("give_meat", increase_stock.bind(true))
			add_child(stock)
			stock.item_icon.item = GOOD_MEAT_RESOURCE
			stock.item_icon._ready()
			stock._ready()
			_on_phone_hide_dialog()
		EVENT.CLIENT_COMPLAINING:
			pass

func increase_stock(is_good_meat : bool):
	_on_phone_show_dialog()
	if is_good_meat:
		increase_good_stock(deal_quantity)
	else:
		increase_bad_stock(deal_quantity)
		
func increase_good_stock(deal_quantity)-> void:
	if current_client == null or not is_instance_valid(current_client):
		is_processing_action = false
		return
	good_stock_amount += deal_quantity
	update_money(deal_price, false)
	print("deal taken")
	take_deal.hide()
	cancel_deal.hide()
	current_client.leave()
	current_client = null
	next_event()
	is_processing_action = false

func increase_stock_uber_eats():
	good_stock_amount += 3
	_on_phone_show_dialog()

func increase_bad_stock(deal_quantity)-> void:
	if current_client == null or not is_instance_valid(current_client):
		is_processing_action = false
		return
	bad_stock_amount += deal_quantity
	update_money(deal_price, false)
	print("deal taken")
	take_deal.hide()
	cancel_deal.hide()
	current_client.leave()
	current_client = null
	next_event()
	is_processing_action = false
	
func _on_service_controller_serve_bad() -> void:
	if is_processing_action:
		return
	if bad_stock_amount > 0 and current_client != null and is_instance_valid(current_client):
		serve.play()
		is_processing_action = true
		bad_stock_amount -= 1
		var paid_money = current_client.receive_bad_food()
		await hide_dialogs_and_buttons()
		if current_client != null and is_instance_valid(current_client):
			current_client.leave()
			current_client = null
		if paid_money == -1:
			hurt()
			#event_queue.push_back(EVENT.CLIENT_COMPLAINING)
		else:
			update_money(paid_money, true)
		next_event()
		is_processing_action = false
		
func _on_service_controller_serve_good() -> void:
	if is_processing_action:
		return
	if good_stock_amount > 0 and current_client != null and is_instance_valid(current_client):
		serve.play()
		is_processing_action = true
		good_stock_amount -= 1
		update_money(current_client.receive_good_food(), true)
		await hide_dialogs_and_buttons()
		if current_client != null and is_instance_valid(current_client):
			current_client.leave()
			current_client = null
		next_event()
		is_processing_action = false
		
func next_client() -> void:
	if is_spawning:
		return
	is_spawning = true
	
	await get_tree().create_timer(1.5).timeout
	if client_queue.size() > 0:
		var client_scene = client_queue.get(0)
		client_queue.remove_at(0)
		add_child(client_scene)
		current_client = client_scene
		player_box.show_dialog_box("I'll give you a....")
		serve_good_button.show()
		serve_bad_button.show()
		good_stock.show()
		bad_stock.show()
		
		if current_client.client_info.type == Client_Info.Type.DEALER \
		or current_client.client_info.type == Client_Info.Type.COP \
		or current_client.client_info.type == Client_Info.Type.FAKE_COP:
			current_client.dialog_system.no_more_dialog.connect(check_dealer, CONNECT_ONE_SHOT)
	else:
		await next_day()
	is_spawning = false

func next_day() -> void:
	current_day += 1
	await spawn_client_asserter()
	
	for client_info in client_infos:
		var client = client_spawner.spawn_client(current_day)
		client.client_info = client_info
		client_queue.push_back(client)
	client_queue.shuffle()

func buy_good_stock_amount() -> void:
	var inst = dealer_called.instantiate()
	if coupon_count > 0 && total_money >= GOOD_BURGER_COST/2:
		add_to_queue_in(EVENT.SPAWN_DEALER, 1)
		phone.disable()
		is_good_meat = true
	elif total_money >= GOOD_BURGER_COST:
		add_to_queue_in(EVENT.SPAWN_DEALER, 1)
		phone.disable()
		is_good_meat = true
	else:
		inst.text = "No money!"
	add_child(inst)
	_on_phone_show_dialog()
		
func buy_bad_stock_amount() -> void:
	if is_processing_action:
		return
	if current_client == null or not is_instance_valid(current_client):
		return
	is_good_meat = false
	current_client.client_info.dealer_is_requested = true
	bad_stock_purchases += 1
	add_to_queue_in(EVENT.SPAWN_DEALER, 1)
	phone.disable()
	var inst = dealer_called.instantiate()
	add_child(inst)
	_on_phone_show_dialog()
	
func _on_bell_bell_pressed() -> void:
	if is_processing_action:
		return
	is_processing_action = true
	
	hurt()
	
	if current_client != null and is_instance_valid(current_client):
		await hide_dialogs_and_buttons()
		if current_client != null and is_instance_valid(current_client):
			current_client.leave()
			current_client = null
	
	next_event()
	is_processing_action = false

func show_game_over()-> void:
	game_over.show()
	Engine.time_scale = 0 

func add_to_queue_in(event: EVENT, pos: int):
	for i in pos:
		if i+1 == pos:
			event_queue.insert(pos-1, event)
		elif event_queue.size() <= i:
			event_queue.push_back(EVENT.SPAWN_CLIENT)

var is_good_meat = true
func _on_take_deal_pressed() -> void:
	if is_processing_action:
		return
	is_processing_action = true
	take_deal.hide()
	cancel_deal.hide()
	if !is_good_meat:
		if current_client != null and is_instance_valid(current_client) and current_client.client_info.type == Client_Info.Type.COP:
			get_caught()
			return
		elif current_client.client_info.type == Client_Info.Type.FAKE_COP:
				get_lucky_fake_cop()
				return
	
		var stock = you_got_stock_scene.instantiate()
		stock.connect("give_meat", increase_stock.bind(false))
		add_child(stock)
		stock.item_icon.item = BAD_MEAT_RESOURCE
		stock.item_icon._ready()
		stock._ready()
	else:
		coupon_count -= 1
		if coupon_count <= 0:
			ItemManager.has_coupon = false
		for i in 3:
			coupons.get_child(i).hide()
		for i in coupon_count:
			coupons.get_child(i).show()
		var stock = you_got_stock_scene.instantiate()
		stock.connect("give_meat", increase_stock.bind(true))
		add_child(stock)
		stock.item_icon.item = GOOD_MEAT_RESOURCE
		stock.item_icon._ready()
		stock._ready()
	is_processing_action = false

func _on_cancel_deal_pressed() -> void:
	if is_processing_action:
		return
	is_processing_action = true
	print("deal cancelled")
	take_deal.hide()
	cancel_deal.hide()
	if current_client != null and is_instance_valid(current_client):
		current_client.leave()
		current_client = null
	next_event()
	is_processing_action = false
	
func check_dealer():
	if !is_good_meat:
		deal_quantity = [3, 5, 8, 10].pick_random()
		deal_price = deal_quantity * [2, 3, 4].pick_random()
		if deal_price > total_money: 
			deal_price = total_money 
		current_client.dialog_system.show_message("Here's the deal: These %d [color=green]EXCELENT[/color] burgers for $%d, do you take them man?" % [deal_quantity, deal_price])
		cancel_deal.show()
		take_deal.show()
	else:
		deal_quantity = [2,3].pick_random()
		deal_price = deal_quantity * 10
		if coupon_count > 0:
			deal_price = deal_price / 2
				
		if deal_price > total_money: 
			current_client.dialog_system.show_message("You called me here and you have no money?")
			current_client.dialog_system.show_message("Get real.")
			await get_tree().create_timer(4).timeout
			current_client.leave()
			next_event()
		else:
			current_client.dialog_system.show_message("Here's the deal: These %d[color=maroon]AFFORDABLE[/color] burgers for $%d, do you take them man?" % [deal_quantity, deal_price])
			cancel_deal.show()
			take_deal.show()
	
	current_client.dialog_system.space_bar.hide()
	
func hide_dialogs_and_buttons() -> void:
	#await dialog_box.hide_dialog_box()
	await player_box.hide_dialog_box()
	serve_good_button.hide()
	serve_bad_button.hide()
	good_stock.hide()
	bad_stock.hide()
	
func show_dialogs_and_buttons():
	#await dialog_box.hide_dialog_box()
	player_box.show_dialog_box("I'll give you a....")
	serve_good_button.show()
	serve_bad_button.show()
	good_stock.show()
	bad_stock.show()
	
func hurt():
	total_health -= 1
	animation_player.play("hurt")
	if total_health <= 0:
		show_game_over()
		is_processing_action = false
		return

func get_caught() -> void:
	take_deal.hide()
	cancel_deal.hide()
	
	if current_client != null and is_instance_valid(current_client):
		current_client.client_info.update_texture_to_type()
		current_client.sprite.texture = current_client.client_info.client_texture
		current_client.dialog_system.face = current_client.client_info.get_face()
		current_client.dialog_system.clear_dialogs()
		current_client.dialog_system.show_message(current_client.client_info.cop_dialog.pick_random())
		current_client.dialog_system.show_message("You have been caught, you will have to pay a 30$ fine now!")
		current_client.dialog_system.space_bar.hide()
		pay_fine.show()
	
	update_money(fine_amount, false)
	await get_tree().create_timer(2.0).timeout
	
	if current_client != null and is_instance_valid(current_client):
		current_client.leave()
		current_client = null
	
	await next_event()
	is_processing_action = false

func update_money(amount: int, is_to_add: bool):
	if is_to_add:
		total_money += amount
		register_audio.stream = CASH_REGISTER_2
		register_audio.pitch_scale = 1
		register_player.play("add_money")
	else:
		total_money -= amount
		register_audio.stream = COINS_2
		register_audio.pitch_scale = 0.5
		register_player.play("remove_money")
			
func get_lucky_fake_cop() -> void:
	take_deal.hide()
	cancel_deal.hide()
	
	if current_client != null and is_instance_valid(current_client):
		current_client.dialog_system.show_message("Oof, you're a lucky guy, I'm not on duty, but I'll be close by!")
	
	await get_tree().create_timer(2.0).timeout
	
	if current_client != null and is_instance_valid(current_client):
		current_client.leave()
		current_client = null
	
	await next_event()
	is_processing_action = false

func _on_phone_hide_dialog() -> void:
	if current_client != null:
		current_client.dialog_system.hide()
	player_box.hide()
	service_controller.hide()
	hide_dialogs_and_buttons()
	
func _on_phone_show_dialog() -> void:
	if current_client != null:
		current_client.dialog_system.show()
	player_box.show()
	service_controller.show()
	show_dialogs_and_buttons()

var is_first_item_clear: bool = true
func first_item_clear():
	_on_phone_show_dialog()
	if is_first_item_clear:
		next_client()
		is_first_item_clear = false

func _on_pay_fine_pressed() -> void:
	pay_fine.hide()
	total_money -= fine_amount
	
	await get_tree().create_timer(2.0).timeout
	
	if current_client != null and is_instance_valid(current_client):
		current_client.leave()
		current_client = null
	
	await next_event()
	is_processing_action = false
