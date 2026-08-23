extends Node2D

enum CLIENT_TYPE {
	NORMAL,
	ASAE,
	COP
}

var type : CLIENT_TYPE = CLIENT_TYPE.NORMAL
@export var preferences : Array[String]
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "I want fries, ferb!"

func _on_hover_component_selected(selected: bool) -> void:
	if selected:
		label.text = "And a burger!"
