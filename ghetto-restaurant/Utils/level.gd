extends Node2D

@onready var client_manager: ClientManager = $ClientManager
var total_money : int = 0
@onready var money: Label = $Money

func _ready() -> void:
	client_manager.spawn_aleatorio()
	
func _on_service_controller_serve_bad() -> void:
	total_money += client_manager.serve_bad_food()
	money.text = str(total_money)
	
func _on_service_controller_serve_good() -> void:
	total_money += client_manager.serve_good_food()
	money.text = str(total_money)
