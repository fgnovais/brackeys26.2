extends Control
class_name DialogSystem

var client_dialog : Array[String] = ["test", "yo", "burger", "hey boss"]
var idx := 0
var dialog_scene : PackedScene = load("res://UI/dialog_box.tscn")
var face : Texture2D
@onready var client_dialogs: VBoxContainer = $ClientDialogs
@onready var player_dialogs: VBoxContainer = $PlayerDialogs
signal no_more_dialog
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var space_bar: TextureRect = $SpaceBar

func _ready() -> void:
	space_bar.hide()
	
func spawn():
	var inst : DialogBox = dialog_scene.instantiate()
	inst.face = face
	inst.global_position = Vector2(0,0)
	client_dialogs.add_child(inst)
	inst.show_dialog_box(client_dialog[idx])
	if idx > 1:
		var tween = create_tween()
		tween.tween_property(client_dialogs, "offset_transform_position", client_dialogs.offset_transform_position + Vector2(0, -200), 1)
	idx+= 1
	#if idx < client_dialogs.get_child_count():
	show_space_bar()

func show_space_bar():
	space_bar.show()
	animation_player.play("bob")
	
func _unhandled_input(event: InputEvent) -> void:
	if idx < client_dialog.size():
		if event.is_action_pressed("space"):
			spawn()
	else:
		no_more_dialog.emit()
		space_bar.hide()

func show_message(text: String) -> void:
	var inst : DialogBox = dialog_scene.instantiate()
	inst.face = face
	client_dialogs.add_child(inst)
	inst.show_dialog_box(text)
	
	if idx > 1:
		var tween = create_tween()
		tween.tween_property(client_dialogs, "offset_transform_position", client_dialogs.offset_transform_position + Vector2(0, -200), 1)

func clear_dialogs() -> void:
	client_dialogs.offset_transform_position = Vector2(0,0)
	for child in client_dialogs.get_children():
		child.queue_free()
	idx = 0
