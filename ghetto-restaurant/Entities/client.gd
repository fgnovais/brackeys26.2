extends Node2D
class_name Client

enum Tipo { NORMAL, ASAE, POLICIA }

@export var tipo: Tipo = Tipo.NORMAL
@export var prato_pedido: String = "prato_do_dia"

@export var textura_normal: Texture2D
@export var textura_asae: Texture2D
@export var textura_policia: Texture2D

@export var balao_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D

var recurso_penalizado: GameState.Recurso
var quantidade_penalidade: int
var balao_instancia: Node2D

const NOMES_PRATOS := {
	"prato_do_dia": "Prato do Dia",
	"sopa": "Sopa da Casa",
	"peixe": "Peixe Grelhado"
}

signal satisfeito(cliente)
signal reclamou(cliente)

func _ready() -> void:
	_configurar_por_tipo()
	_mostrar_balao()

func _configurar_por_tipo() -> void:
	match tipo:
		Tipo.NORMAL:
			recurso_penalizado = GameState.Recurso.DINHEIRO
			quantidade_penalidade = 10
			sprite.texture = textura_normal
		Tipo.ASAE:
			recurso_penalizado = GameState.Recurso.SAUDE_PUBLICA
			quantidade_penalidade = 15
			sprite.texture = textura_asae
		Tipo.POLICIA:
			recurso_penalizado = GameState.Recurso.SEGURANCA
			quantidade_penalidade = 15
			sprite.texture = textura_policia

func _mostrar_balao() -> void:
	if balao_scene == null:
		return
	balao_instancia = balao_scene.instantiate()
	add_child(balao_instancia)
	balao_instancia.position = Vector2(0, -100)  # ajusta consoante o tamanho do sprite
	var nome_bonito: String = NOMES_PRATOS.get(prato_pedido, prato_pedido)
	balao_instancia.mostrar_pedido(nome_bonito)

func pedir_prato() -> String:
	return prato_pedido

func avaliar_prato(prato_servido: String) -> void:
	if balao_instancia:
		balao_instancia.esconder()

	if prato_servido == prato_pedido:
		satisfeito.emit(self)
	else:
		reclamou.emit(self)
		GameState.aplicar_penalidade(recurso_penalizado, quantidade_penalidade)
