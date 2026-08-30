extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE, COP, FAKE_COP, FAKE_ASAE, DEALER }

var type: Type = Type.NORMAL
var client_texture: Texture2D = load("res://Assets/texture1.png")
var dialog : Array = ["Yo! Can i get a burger, please?","A burger would be good!"]
var cop_dialog : Array[String] = ["This is the police!", "I've got some questions for you."]
var dealer_dialog : Array[String] = ["Yo, you got the stuff?", "Let's make this quick, man."]
var inspector_dialog : Array[String] = ["This burger is in violation of EVERY health guideline!", "I'll be writing a report about this."]
var dealer_is_requested : bool = false
var asae_odd: float = 0.2
var cop_odd: float = 0.2
var fake_cop_odd: float = 0.1
var fake_asae_odd: float = 0.1

var normal_dialogs: Array[Array] = [
	["Yo! Can i get a burger, please?","A burger would be good!"],
	["Been waiting for ages!","Can't wait to get a burger."],
	["I want a burger.", "I'm a loyal customer."],
	["If I don't get a good burger I'll sue you.", "Will you take responsability?"],
	["I'm a health inspector, you better treat me well.", "Did you get that?"],
	["My dad is a health inspector.", "Treat me well, you hear?"],
	["I better get a good burger, this time.", "You served me rotten meat last time!"],
	["This stench is disgusting.", "But you can't beat these burgers."],
	["I've been waiting for a long time", "You better serve me well!"],
	["Something about these burgers keeps me coming back.", "The sauce is special I think."],
	["This place is disgusting.", "I'll take a large burger, please."],
	["I hate this smell.", "I'll write a report about this!"],
	["If I get a bad a burger I'll write a report about this place.", "I like my job."],
	["I want the best burgers ONLY.", "I can tell when you use bad meat."],
	["The meat gives this place its charm.", "I can't get enough."],
	["I love this meat.", "I can't get enough of it."],
	["I can't wait to get a burger on my hands!.", "Let's go!."],
	["I've waited so long for this.", "I want to eat a burger right now!."],
	["I can tell when you use the cheap meat.", "I only want the best."],
	["I'll give you a poor rating if you give me that meat again!", "You never learn, do you?"],
	["I don't want fries, I only want BURGER.", "Give me my burger!."],
	["I don't want to wait any longer!", "I want your best burger, right now!"],
	["The last rating I gave you didn't scare you?", "I'll do it again if you feed me that cheap meat!"],
	["I keep coming back to this place.", "It's my comfort food."],
	["I've eaten so much of this burger.", "I should get a trophy!"],
	["My business card is on the back.", "It says 'BURGER LOVER', for a reason."],
	["It's been 3 days since I last came here.", "I'm craving that burger!"],
	["I only want two things. A burger.", "And that someone cleans up this place!"],
	["I've gotten used to this stench.", "I can't eat burgers without it now!"],
	["This meat is really something special.", "I crave it everyday!"],
]
	
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
	update_dialog_to_type()

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

var amounts = [0,0,0,0]
func give_normal_texture():
	#var id = [1,2,3,4].pick_random()
	#amounts[id] = amounts[id] + 1
	#var highest = 0
	#for i in amounts:
		#if i > highest:
			#highest = i
	#if amounts[id] == highest:
		#give_normal_texture()
		
	var textures = ["res://Assets/texture1.png","res://Assets/texture2.png","res://Assets/texture3.png","res://Assets/texture4.png"]
	client_texture = load(textures.pick_random())

func update_dialog_to_type() -> void:
	if type == Type.DEALER:
		dialog = dealer_dialog
	elif type == Type.COP or type == Type.FAKE_COP:
		dialog = cop_dialog
	else:
		dialog = normal_dialogs.pick_random()

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
			
const FELIZ_1 = preload("uid://dqqog65vuvptf")
const FELIZ_2 = preload("uid://cuokpltc00u7h")
const FELIZ_3 = preload("uid://b5vyljieuqien")
const FELIZ_4 = preload("uid://dkvd6be4mf4fi")
const FELIZ_5 = preload("uid://t688afk8sjor")
const SUSPIRO = preload("uid://cpeuav6od8gkw")

func get_happy_voice():
	match client_texture:
		INSPECTOR:
			return FELIZ_4
		GHOST	:
			return FELIZ_5
		FORK:
			return FELIZ_2
		KETCHUP:
			return FELIZ_3
		SUNGLASSES:
			return FELIZ_1
		_:
			return FELIZ_4

const VOZ_TRISTE_1 = preload("uid://bl1dwyi182e0v")
const VOZ_TRISTE_2 = preload("uid://hevrwqajyucs")
const VOZ_TRISTE_3 = preload("uid://ba456sjje0plm")
const VOZ_TRISTE_5 = preload("uid://d0h8upsaq1lil")

func get_sad_voice():
	match client_texture:
		INSPECTOR:
			return VOZ_TRISTE_1
		GHOST	:
			return VOZ_TRISTE_2
		FORK:
			return VOZ_TRISTE_5
		SUNGLASSES:
			return VOZ_TRISTE_3
		_:
			return VOZ_TRISTE_1
