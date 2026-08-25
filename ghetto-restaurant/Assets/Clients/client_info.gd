extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE }
var type: Type

var client_texture: Texture2D = load("res://Assets/texture1.png")
var asae_odd: float = 0.2
var chance_to_complain : float = 0.3

func _init() -> void:
	var textures =  ["res://Assets/texture1.png","res://Assets/texture2.png","res://Assets/texture3.png","res://Assets/texture4.png"]
	client_texture = load(textures.pick_random())
	get_type()
	
func get_type() -> void:
	var r = randf()
	if r < asae_odd:
		type = Client_Info.Type.ASAE
	else:
		type = Client_Info.Type.NORMAL
