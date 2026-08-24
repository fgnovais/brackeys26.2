extends Node2D
class_name ClientSpawner

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
	
