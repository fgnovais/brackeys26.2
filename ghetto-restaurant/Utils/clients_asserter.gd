extends Control

var client_scene : PackedScene = load("res://UI/client.tscn") 
@onready var h_box_container: GridContainer = $Box/HBoxContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var HIGHLIGHT = preload("uid://d25a46rib4y4v")
const INSPECTOR_HIGHLIGHT = preload("uid://dspccllwrqw0k")
@onready var start: Button = $Start

signal start_level
var label_text = "%s Clients
%s Inspectors

Feed a bad burger to an inspector if you want to lose.
Can you guess who is who?"
@onready var label: Label = $Label


func _ready() -> void:
	start.hide()
	animation_player.play("spawn")
	
func populate_day(current_day: int) -> Array[Client_Info]:
	var clients_amount = 2
	var inspectors_amount = 2
	var entities_array : Array[Client_Info] = []	
	
	match current_day:
		1:
			clients_amount = 4
			inspectors_amount = 2
		2:
			clients_amount = 6
			inspectors_amount = 5
		3:
			clients_amount = 4
			inspectors_amount = 8
	
	for i in clients_amount:
		var client_info = Client_Info.new()
		client_info.type = Client_Info.Type.NORMAL
		client_info.update_texture_to_type()
		entities_array.push_back(client_info)
		
		var text_rec = TextureRect.new()
		text_rec.offset_transform_enabled = true
		text_rec.texture = client_info.client_texture
		h_box_container.add_child(text_rec)
		await get_tree().create_timer(0.2).timeout
	label.text = "%s Clients" % clients_amount
	await get_tree().create_timer(2).timeout
	
	for i in inspectors_amount:
		var client_info = Client_Info.new()
		client_info.type = Client_Info.Type.ASAE
		client_info.update_texture_to_type()
		entities_array.push_back(client_info)
		
		var text_rec = TextureRect.new()
		text_rec.offset_transform_enabled = true
		text_rec.texture = client_info.client_texture
		h_box_container.add_child(text_rec)
		await get_tree().create_timer(0.2).timeout
	
	label.text = "%s Clients" % clients_amount + "
	%s Inspectors" % inspectors_amount
	await get_tree().create_timer(1).timeout
	
	label.text = label_text % [str(clients_amount), str(inspectors_amount)]
		
	for ent in entities_array:
		print("Current client: ", Client_Info.Type.keys()[ent.type])
	await play_animation(entities_array)
	
	return entities_array
	
func play_animation(entities_array : Array[Client_Info]):
	for i in entities_array.size():
		var info : Client_Info = entities_array[i]
		var square : TextureRect = h_box_container.get_children()[i]
		if info.type == Client_Info.Type.ASAE:
			square.material = ShaderMaterial.new()
			square.material = INSPECTOR_HIGHLIGHT
			await get_tree().create_timer(1).timeout
	
	await get_tree().create_timer(3).timeout
	
	#get positions
	var positions: Array[Vector2] = []
	for ent in h_box_container.get_children():
		positions.push_back(ent.position)
	
	var target_position = Vector2(1500, 600)

	for child in h_box_container.get_children():
		var offset_needed = target_position - (child.global_position*2) + Vector2(randf_range(-100, 100), randf_range(-100, 100))
		var tween = create_tween().set_parallel(true)
		tween.tween_property(child, "offset_transform_position", offset_needed, 1)
		#child.offset_position = offset_needed

	await get_tree().create_timer(1).timeout
	#for ent in h_box_container.get_children():
		#var tween = create_tween().set_parallel(true)
		#tween.tween_property(ent, "position", Vector2(1000 + randf_range(200, -200),randf_range(-150, 150)), 2)
	#await get_tree().create_timer(2).timeout
		
	for e in 5:
		for i in entities_array.size():
			var info = entities_array[i]
			info.give_normal_texture()
			var square : TextureRect = h_box_container.get_children()[i]
			square.material = null
			square.texture = info.client_texture
		await get_tree().create_timer(0.2).timeout
			
	await get_tree().create_timer(1).timeout
	
	var idx = 0
	for ent in h_box_container.get_children():
		var tween = create_tween().set_parallel(true)
		tween.tween_property(ent, "offset_transform_position", Vector2.ZERO, 2)
		idx+= 1
				
	await get_tree().create_timer(3).timeout
	start.show()
	
func _on_start_pressed() -> void:
	start_level.emit()
	animation_player.play("kill")
	await get_tree().create_timer(2).timeout
	queue_free()
