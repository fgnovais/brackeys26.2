extends Node2D
class_name ClientManager

@export var client_scene: PackedScene  
@export var dealer_scene: PackedScene   

@onready var spawn_point: Marker2D = $SpawnPoint

func spawn_client(tipo: Client.Tipo) -> void:
	var c: Client = client_scene.instantiate()
	c.tipo = tipo
	c.position = spawn_point.position
	add_child(c) 

func spawn_aleatorio() -> void:
	var r = randf()
	if r < 0.7:
		spawn_client(Client.Tipo.NORMAL)
	elif r < 0.85:
		spawn_client(Client.Tipo.ASAE)
	elif r < 0.95:
		spawn_client(Client.Tipo.POLICIA)
	else:
		var d = dealer_scene.instantiate()
		d.position = spawn_point.position
		add_child(d)
