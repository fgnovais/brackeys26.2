extends Node2D
class_name ClientManager

@export var client_scene: PackedScene  
@export var dealer_scene: PackedScene   

@onready var spawn_point: Marker2D = $SpawnPoint

func spawn_client(tipo: Client.Tipo) -> Client:
	var c: Client = client_scene.instantiate()
	c.tipo = tipo
	c.global_position = spawn_point.global_position
	return c 

func spawn_aleatorio() -> Client:
	var r = randf()
	if r < 0.7:
		return spawn_client(Client.Tipo.NORMAL)
	elif r < 0.85:
		return spawn_client(Client.Tipo.ASAE)
	elif r < 0.95:
		return spawn_client(Client.Tipo.POLICIA)
	return spawn_client(Client.Tipo.NORMAL)
	#else:
		#var d = dealer_scene.instantiate()
		#d.position = spawn_point.position
		#add_child(d)

func serve_good_food(client:Client) -> int:
	var money_back = client.receive_good_food()
	return money_back
	
func serve_bad_food(client:Client) -> int:
	var money_back = client.receive_bad_food()
	return money_back
	
