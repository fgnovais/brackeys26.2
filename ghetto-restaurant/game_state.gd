extends Node 

var dinheiro: int = 100
var saude_publica: int = 100
var seguranca_publica: int = 100

signal recurso_alterado(tipo, novo_valor)

enum Recurso { DINHEIRO, SAUDE_PUBLICA, SEGURANCA }

func aplicar_penalidade(tipo: Recurso, quantidade: int) -> void:
	match tipo:
		Recurso.DINHEIRO:
			dinheiro -= quantidade
			recurso_alterado.emit(tipo, dinheiro)
		Recurso.SAUDE_PUBLICA:
			saude_publica -= quantidade
			recurso_alterado.emit(tipo, saude_publica)
		Recurso.SEGURANCA:
			seguranca_publica -= quantidade
			recurso_alterado.emit(tipo, seguranca_publica)

func adicionar_dinheiro(quantidade: int) -> void:
	dinheiro += quantidade
	recurso_alterado.emit(Recurso.DINHEIRO, dinheiro)
