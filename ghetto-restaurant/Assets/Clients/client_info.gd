extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE, COP, FAKE_COP, FAKE_ASAE, DEALER }

var type: Type = Type.NORMAL
var client_texture: Texture2D = load("res://Assets/texture1.png")
var dialog : Array[String] = ["Yo! Can i get a burger, please?","A burger would be good!"]
var cop_dialog : Array[String] = ["This is the police!", "I've got some questions for you."]
var dealer_dialog : Array[String] = ["Yo, you got the stuff?", "Let's make this quick, man."]

var dealer_is_requested : bool = false
var asae_odd: float = 0.2
var cop_odd: float = 0.2
var fake_cop_odd: float = 0.1
var fake_asae_odd: float = 0.1

var day : int = 1
static var type_queue: Array[Type] = []
static var type_queue_day: int = -1

func _init(d: int = 1) -> void:
	day = d
	
	asae_odd = [0.3, 0.4, 0.5, 0.6].pick_random()
	cop_odd = asae_odd * [0.1, 0.15, 0.2, 0.25, 0.3].pick_random()
	give_normal_texture()
	
	if day > 4:
		get_type_chaos_day()
	else:
		get_type()
	
	update_texture_to_type()

func get_type() -> void:
	if dealer_is_requested == true:
		type = Client_Info.Type.DEALER
		update_texture_to_type()
		update_dialog_to_type()
		print("Current client: ", Client_Info.Type.keys()[type])
		return
	
	#if Client_Info.type_queue_day != day:
		#Client_Info.type_queue_day = day
		#Client_Info.type_queue = _build_day_queue(day)
	
	if Client_Info.type_queue.size() > 0:
		type = Client_Info.type_queue.pop_back()
	else:
		type = Client_Info.Type.NORMAL
	
	print("Current client: ", Client_Info.Type.keys()[type])

func get_type_chaos_day() -> void:
	if dealer_is_requested == true:
		type = Client_Info.Type.DEALER
		update_texture_to_type()
		update_dialog_to_type()
		print("Current client: ", Client_Info.Type.keys()[type])
		return
	
	var r = randf()
	if r < asae_odd:
		type = Client_Info.Type.ASAE
		var r_fake = randf()
		if r_fake < fake_asae_odd:
			type = Client_Info.Type.FAKE_ASAE
	else:
		type = Client_Info.Type.NORMAL
	
	print("Current client: ", Client_Info.Type.keys()[type])

#func _build_day_queue(d: int) -> Array[Type]:
	#var asae_count := 0
	#var normals := 0
	#match d:
		#1:
			#asae_count = 2; normals = 4
		#2:
			#asae_count = 3; normals = 5
		#3:
			#asae_count = 4; normals = 6
		#4:
			#asae_count = 8; normals = 12
	#
	#var q : Array[Type] = []
	#for i in asae_count:
		#q.append(Type.ASAE)
	#for i in normals:
		#q.append(Type.NORMAL)
	#q.shuffle()
	#return q

func request_cop() -> void:
	
	type = Client_Info.Type.COP
	var r_fake = randf()
	if r_fake < fake_cop_odd:
		type = Client_Info.Type.FAKE_COP
	print("Current client: ", Client_Info.Type.keys()[type])
	client_texture = DEALER
	dialog = dealer_dialog

func update_texture_to_type() -> void:
	if type == Type.DEALER:
		client_texture = DEALER
	elif type == Type.ASAE:
		client_texture = INSPECTOR
	elif type == Type.COP:
		client_texture = COP

func give_normal_texture():
	var textures = ["res://Assets/texture1.png","res://Assets/texture2.png","res://Assets/texture3.png","res://Assets/texture4.png"]
	client_texture = load(textures.pick_random())

func update_dialog_to_type() -> void:
	if type == Type.DEALER:
		dialog = dealer_dialog
	elif type == Type.COP or type == Type.FAKE_COP:
		dialog = cop_dialog

### 
const COP = preload("uid://bmh1fc8ur5fc3")
const DEALER = preload("uid://bjtnndfbi3up8")
const INSPECTOR = preload("uid://wl75tsdp5frb")
const SUNGLASSES = preload("uid://dmcwbxodhg4jk")
const GHOST = preload("uid://dddnisudwu527")
const FORK = preload("uid://dv8y8r2ioak0t")
const KETCHUP = preload("uid://lon6poba18uy")
const COP_FACE = preload("uid://oesd77fs1cu7")
const DEALER_FACE = preload("uid://buaxippy17r40")
const FORK_FACE = preload("uid://csbkr38hfn3o5")
const GHOST_FACE = preload("uid://debtllxvajs1w")
const INSPECTOR_FACE = preload("uid://bnk4twm8g0j4s")
const KETCHUP_FACE = preload("uid://b8im052gipvq1")
const SUNGLASSES_FACE = preload("uid://cprf3y783hr0x")

func get_face() -> Texture2D:
	match client_texture:
		COP:
			return COP_FACE
		INSPECTOR:
			return INSPECTOR_FACE
		GHOST	:
			return GHOST_FACE
		FORK:
			return FORK_FACE
		KETCHUP:
			return KETCHUP_FACE
		DEALER:
			return DEALER_FACE
		SUNGLASSES:
			return SUNGLASSES_FACE
		_:
			return FORK_FACE
