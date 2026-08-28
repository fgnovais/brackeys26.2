extends Control

var client_scene : PackedScene = load("res://UI/client.tscn") 
@onready var h_box_container: HBoxContainer = $Box/HBoxContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal start_level
func _ready() -> void:
	animation_player.play("spawn")
	
func populate_day(current_day: int) -> Array[Client]:
	var clients_amount = 2
	var inspectors_amount = 2
	var entities_array : Array[Client] = []	
	#var cop_amount = 1
	
	match current_day:
		1:
			clients_amount = 4
			inspectors_amount = 2
			#cop_amount = 1
		2:
			clients_amount = 6
			inspectors_amount = 5
			#cop_amount = 1
		3:
			clients_amount = 4
			inspectors_amount = 8
			#cop_amount = 2
		
	for i in clients_amount:
		var client : Client = client_scene.instantiate()
		client.client_info = Client_Info.new()
		client.client_info.type = Client_Info.Type.NORMAL
		client.client_info.update_texture_to_type()
		add_child(client)
		var text_rec = TextureRect.new()
		text_rec.offset_transform_enabled = true
		text_rec.texture = client.client_info.client_texture
		h_box_container.add_child(text_rec)
		entities_array.push_back(client)
		
	for i in inspectors_amount:
		var client : Client = client_scene.instantiate()
		#client.inspector = true
		client.client_info = Client_Info.new()
		client.client_info.type = Client_Info.Type.ASAE
		client.client_info.update_texture_to_type()
		add_child(client)
		var text_rec = TextureRect.new()
		text_rec.offset_transform_enabled = true
		text_rec.texture = client.client_info.client_texture
		h_box_container.add_child(text_rec)
		entities_array.push_back(client)
		
	#for i in cop_amount:
		#var client : Client = client_scene.instantiate()
	##	client.cop = true
		#client.client_info = Client_Info.new()
		#client.client_info.type = Client_Info.Type.COP
		#client.client_info.update_texture_to_type()
		#add_child(client)
		#var text_rec = TextureRect.new()
		#text_rec.offset_transform_enabled = true
		#text_rec.texture = client.client_info.client_texture
		#h_box_container.add_child(text_rec)
		#entities_array.push_back(client)
	
	for ent in entities_array:
		ent.hide()
		print("Current client: ", Client_Info.Type.keys()[ent.client_info.type])
	await play_animation(entities_array)
	
	return entities_array
	
func play_animation(entities_array : Array[Client]):
	var idx = 1
	for ent in h_box_container.get_children():
		var tween = create_tween().set_parallel(true)
		var range := 1
		match idx :
			1:
				range = 1000
			2:
				range = 800
			3:
				range = 400
			4:
				range = 0
			5:
				range = -400
			6:
				range = -600
			7:
				range = -800
			8:
				range = -1200
			7:
				range = -1400
			9:
				range = -1600
			10:
				range = -1800
			11:
				range = -2000
			12:
				range = -2200
			13:
				range = -2400
			14:
				range = -2600
			15:
				range = -2800
				
		tween.tween_property(ent, "offset_transform_position", Vector2(range,randf_range(-150, 150)), 2)
		idx+=1
		
	await get_tree().create_timer(4).timeout
	
	for i in entities_array.size():
		var ent = entities_array[i]
		var square : TextureRect = h_box_container.get_children()[i]
		if ent.client_info.type != Client_Info.Type.NORMAL:
			ent.client_info.give_normal_texture()
			ent.sprite.texture = ent.client_info.client_texture
			square.texture = ent.client_info.client_texture
			
	for ent in h_box_container.get_children():
		var tween = create_tween()
		tween.tween_property(ent, "offset_transform_position", Vector2(0,0), 3)
	await get_tree().create_timer(3).timeout
	
func _on_start_pressed() -> void:
	start_level.emit()
	animation_player.play("kill")
	await get_tree().create_timer(2).timeout
	queue_free()
