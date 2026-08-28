extends Node2D
class_name Client

@export var balao_scene: PackedScene
var client_info : Client_Info
@onready var sprite: Sprite2D = $Client
@onready var dialog: Label = $Dialog
@onready var percentage: Label = $Percentage
@onready var arrive_sound: AudioStreamPlayer = $ArriveSound
@onready var leave_sound: AudioStreamPlayer = $LeaveSound
@onready var complain_sound: AudioStreamPlayer = $ComplainSound

var money
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#signal satisfeito(cliente)
#signal reclamou(cliente)

func _ready() -> void:
	#_configurar_por_tipo()
	#_mostrar_balao()
	money = 5
	#client_info.spawn_aleatorio()
	sprite.texture = client_info.client_texture
	animation_player.play("arrive")
	animation_player.animation_finished.connect(transition_animations)
	dialog.text = client_info.dialog.pick_random()
	#percentage.text = str(client_info.asae_odd*100) + "%	"
	percentage.hide()
	arrive_sound.play()

func transition_animations(anim_name : String):
	if anim_name == "arrive":
		animation_player.play("idle")
	elif anim_name == "leave":
		queue_free()

func leave():
	animation_player.play("leave")
	dialog.text = "I'm Leaving!"
	leave_sound.play()
	
#func _configurar_por_tipo() -> void:
	#match tipo:
		#Tipo.NORMAL:
			#recurso_penalizado = GameState.Recurso.DINHEIRO
			#quantidade_penalidade = 10
			#sprite.texture = textura_normal
		#Tipo.ASAE:
			#recurso_penalizado = GameState.Recurso.SAUDE_PUBLICA
			#quantidade_penalidade = 15
			#sprite.texture = textura_asae
		#Tipo.POLICIA:
			#recurso_penalizado = GameState.Recurso.SEGURANCA
			#quantidade_penalidade = 15
			#sprite.texture = textura_policia

#func _mostrar_balao() -> void:
	##if balao_scene == null:
	#return
	#balao_instancia = balao_scene.instantiate()
	#add_child(balao_instancia)
	#balao_instancia.position = Vector2(0, -100)  # ajusta consoante o tamanho do sprite
	#var nome_bonito: String = NOMES_PRATOS.get(prato_pedido, prato_pedido)
	#balao_instancia.mostrar_pedido(nome_bonito)

#func pedir_prato() -> String:
	#return prato_pedido
#
#func avaliar_prato(prato_servido: String) -> void:
	#if balao_instancia:
		#balao_instancia.esconder()
#
	#if prato_servido == prato_pedido:
		#satisfeito.emit(self)
	#else:
		#reclamou.emit(self)
		#GameState.aplicar_penalidade(recurso_penalizado, quantidade_penalidade)

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
