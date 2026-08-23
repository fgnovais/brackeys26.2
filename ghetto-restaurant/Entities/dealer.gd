extends Node2D
class_name Dealer

@export var preco_normal: int = 20
@export var preco_dealer: int = 10
@export var risco_por_compra: int = 8
@export var limite_compras_seguidas: int = 3

var compras_seguidas: int = 0

signal oferta_feita(dealer)

func oferecer() -> void:
	oferta_feita.emit(self)

func jogador_comprou() -> void:
	GameState.adicionar_dinheiro(preco_normal - preco_dealer) 
	compras_seguidas += 1
	if compras_seguidas > limite_compras_seguidas:
		var excesso = compras_seguidas - limite_compras_seguidas
		GameState.aplicar_penalidade(GameState.Recurso.SEGURANCA, risco_por_compra * excesso)

func jogador_recusou() -> void:
	compras_seguidas = 0 
