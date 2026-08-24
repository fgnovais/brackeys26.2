extends Resource
class_name Client_Info

enum Type { NORMAL, ASAE, POLICE }


@export var client_texture: Texture2D
@export var type: Type
@export var asae_odd: float = 0.2
@export var police_odd: float = 0.05


func _init() -> void:
	spawn_aleatorio()
	
func spawn_aleatorio() -> void:
	var r = randf()
	if r < asae_odd && r > police_odd:
		type= Client_Info.Type.ASAE
	elif r < police_odd:
		type= Client_Info.Type.POLICE
	else:
		type= Client_Info.Type.NORMAL

#func apply() -> void:
	#ClientManager.apply(type)
