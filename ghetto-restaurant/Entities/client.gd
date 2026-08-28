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


func _ready() -> void:
	money = 5
	sprite.texture = client_info.client_texture
	animation_player.play("arrive")
	animation_player.animation_finished.connect(transition_animations)
	dialog.text = client_info.dialog.pick_random()
	percentage.hide()
	arrive_sound.play()
	dialog_system.client_dialog = client_info.dialog
	dialog_system.face = client_info.get_face()
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


func refresh_dialog() -> void:
	dialog_system.client_dialog = client_info.dialog
	dialog_system.idx = 0
	dialog_system.face = client_info.get_face()
