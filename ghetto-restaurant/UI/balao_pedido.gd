extends Node2D

@onready var label: Label = $NinePatchRect/Label

func mostrar_pedido(texto: String) -> void:
	label.text = texto
	visible = true

func esconder() -> void:
	visible = false
