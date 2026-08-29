extends Node2D
class_name Client

var client_info : Client_Info
var money
@onready var sprite: Sprite2D = $Client
@onready var type: Label = $Type
@onready var arrive_sound: AudioStreamPlayer = $ArriveSound
@onready var leave_sound: AudioStreamPlayer = $LeaveSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialog_system: DialogSystem = $DialogSystem
const COMPLAIN = preload("uid://btsqleifxyl8b")
const LAUGH = preload("uid://bkjyu0dftbd1a")

func _ready() -> void:
	money = 5
	sprite.texture = client_info.client_texture
	animation_player.play("arrive")
	animation_player.animation_finished.connect(transition_animations)
	type.text = "Regular Customer"
	type.hide()
	arrive_sound.play()
	dialog_system.client_dialog =  client_info.dialog
	dialog_system.face = client_info.get_face()
	dialog_system.spawn()
	leave_sound.stream = client_info.get_sad_voice()
	
	match client_info.type:
		Client_Info.Type.NORMAL:
			type.text = "Regular Customer"
		Client_Info.Type.ASAE:
			type.text = "REAL Health Inspector"
		Client_Info.Type.COP:
			type.text = "REAL Cop"
		Client_Info.Type.DEALER:
			type.text = "Meat dealer"
		Client_Info.Type.FAKE_ASAE:
			type.text = "FAKE Health Inspector"
		Client_Info.Type.FAKE_COP:
			type.text = "FAKE Cop"

func transition_animations(anim_name : String):
	if anim_name == "arrive":
		animation_player.play("idle")
	elif anim_name == "leave":
		queue_free()

func leave():
	animation_player.play("leave")
	if Client_Info.Type.DEALER == client_info.type:
		leave_sound.stream = client_info.get_happy_voice()
	leave_sound.play()

func receive_good_food()->int:
	leave_sound.stream = client_info.get_happy_voice()
	return money

func receive_bad_food():
	var chance_to_complain = 100
	match client_info.type:
		Client_Info.Type.ASAE:
			chance_to_complain = 100
		_:
			chance_to_complain = 0
	
	if chance_to_complain >= randi_range(0, 100):
		leave_sound.stream = client_info.get_sad_voice()
		return -1
	else:
		leave_sound.stream = client_info.get_happy_voice()
		return money

func refresh_dialog() -> void:
	dialog_system.client_dialog = client_info.dialog
	dialog_system.idx = 0
	dialog_system.face = client_info.get_face()
