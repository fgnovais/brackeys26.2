extends Node2D
class_name Client

var client_info : Client_Info
var money
@onready var sprite: Sprite2D = $Client
@onready var dialog: Label = $Dialog
@onready var percentage: Label = $Percentage
@onready var arrive_sound: AudioStreamPlayer = $ArriveSound
@onready var leave_sound: AudioStreamPlayer = $LeaveSound
@onready var complain_sound: AudioStreamPlayer = $ComplainSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog_system: DialogSystem = $DialogSystem
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

func _ready() -> void:
	money = 5
	sprite.texture = client_info.client_texture
	animation_player.play("arrive")
	animation_player.animation_finished.connect(transition_animations)
	dialog.text = client_info.dialog.pick_random()
	percentage.hide()
	arrive_sound.play()
	dialog_system.client_dialog = client_info.dialog
	dialog_system.face = get_face()
	dialog_system.spawn()

func transition_animations(anim_name : String):
	if anim_name == "arrive":
		animation_player.play("idle")
	elif anim_name == "leave":
		queue_free()

func leave():
	animation_player.play("leave")
	dialog.text = "I'm Leaving!"
	leave_sound.play()

func receive_good_food()->int:
	dialog.text = "Thanks!"
	return money

func receive_bad_food():
	var chance_to_complain = 100
	match client_info.type:
		Client_Info.Type.ASAE:
			chance_to_complain = 100
		_:
			chance_to_complain = 0
	
	if chance_to_complain >= randi_range(0, 100):
		complain_sound.play()
		return -1
	else:
		return money

func get_face() -> Texture2D:
	match client_info.client_texture:
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

func refresh_dialog() -> void:
	dialog_system.client_dialog = client_info.dialog
	dialog_system.idx = 0
	dialog_system.face = get_face()
