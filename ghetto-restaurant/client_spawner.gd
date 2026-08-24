extends Node2D
class_name ClientSpawner

@export var client_scene: PackedScene  
@export var dealer_scene: PackedScene   

@onready var spawn_point: Marker2D = $SpawnPoint
var client_resources : Array[Client_Info]
const C_LIENT_ASAE = preload("uid://bcrpnv1lff03s")
const CLIENT_NORMAL = preload("uid://iu1hleornxbi")
const CLIENT_POLICE = preload("uid://bxjtkg4ijlw0r")

func _ready() -> void:
	client_resources.push_back(C_LIENT_ASAE)
	client_resources.push_back(CLIENT_NORMAL)
	client_resources.push_back(CLIENT_POLICE)

func spawn_client() -> Client:
	var c: Client = client_scene.instantiate()
	c.client_info = client_resources.pick_random()
	c.global_position = spawn_point.global_position
	return c 
