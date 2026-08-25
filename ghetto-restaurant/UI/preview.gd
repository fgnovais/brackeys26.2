extends Control

var next_queue : Array[Level.EVENT]
var spawn_client_texture = load("res://Assets/texture1.png")
var spawn_cop_texture = load("res://Assets/cop.png")
var spawn_dealer_texture = load("res://Assets/dealer.png")
var get_stock_texture = load("res://UI/bell.png")
var get_item_texture = load("res://UI/client.png")
@onready var h_box_container: HBoxContainer = $TextureRect/HBoxContainer

func update_textures():
	for i in next_queue.size():
		var event = next_queue[i]
		match event:
			Level.EVENT.SPAWN_CLIENT:
				h_box_container.get_child(i).texture = spawn_client_texture
			Level.EVENT.SPAWN_COP:
				h_box_container.get_child(i).texture = spawn_cop_texture
			Level.EVENT.SPAWN_DEALER:
				h_box_container.get_child(i).texture = spawn_dealer_texture
			Level.EVENT.STOCK_ARRIVING:
				h_box_container.get_child(i).texture = get_stock_texture
			Level.EVENT.GIVE_ITEM:
				h_box_container.get_child(i).texture = get_item_texture
			_:
				h_box_container.get_child(i).texture = null
