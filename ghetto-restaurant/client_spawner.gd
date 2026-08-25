extends Node2D
class_name ClientSpawner

@export var client_scene: PackedScene  
@export var dealer_scene: PackedScene   

@onready var spawn_point: Marker2D = $SpawnPoint

func spawn_client() -> Client:
	var c: Client = client_scene.instantiate()
	c.client_info = Client_Info.new()
	c.global_position = spawn_point.global_position
	return c 
