extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE, COP, FAKE_COP, FAKE_ASAE, DEALER }

var type: Type = Type.NORMAL
var client_texture: Texture2D = load("res://Assets/texture1.png")

var dialog : Array[String] = ["Yo! Can i get a burger, please?","A burger would be good!"]
var dealer_is_requested : bool = false
const COP = preload("uid://bmh1fc8ur5fc3")
const DEALER = preload("uid://bjtnndfbi3up8")
const INSPECTOR = preload("uid://wl75tsdp5frb")

func _init() -> void:
	give_normal_texture()
	update_texture_to_type()
		
func update_texture_to_type() -> void:
	if type == Type.DEALER:
		client_texture = DEALER
	elif type == Type.ASAE:
		client_texture = INSPECTOR
	elif type == Type.COP:
		client_texture = COP
	
func give_normal_texture():
	var textures = [ "res://Assets/texture1.png","res://Assets/texture2.png","res://Assets/texture3.png","res://Assets/texture4.png"]
	client_texture = load(textures.pick_random())
