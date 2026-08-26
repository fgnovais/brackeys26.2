extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE, COP, FAKE_COP, FAKE_ASAE }

var type: Type
var client_texture: Texture2D = load("res://Assets/texture1.png")
var asae_odd: float = 0.2
var cop_odd: float = 0.2
var fake_cop_odd: float = 0.1
var fake_asae_odd: float = 0.1
var chance_to_complain : float = 0.3
var dialog : Array[String] = ["Yo! Can i get a burger, please?","A burger would be good!"]

func _init() -> void:
	var textures = ["res://Assets/texture1.png","res://Assets/texture2.png","res://Assets/texture3.png","res://Assets/texture4.png"]
	client_texture = load(textures.pick_random())
	
	asae_odd = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1].pick_random()
	cop_odd = asae_odd * [0.1, 0.15, 0.2, 0.25, 0.3].pick_random()
	chance_to_complain = [0.2, 0.8].pick_random()
	get_type()

func get_type() -> void:
	var r = randf()
	if r < cop_odd:
		type = Client_Info.Type.COP
		var r_fake = randf()
		if r_fake < fake_cop_odd:
			type = Client_Info.Type.FAKE_COP
	elif r < asae_odd:
		type = Client_Info.Type.ASAE
		var r_fake = randf()
		if r_fake < fake_asae_odd:
			type = Client_Info.Type.FAKE_ASAE
	else:
		type = Client_Info.Type.NORMAL
	
	print("Current client: ", Client_Info.Type.keys()[type])
