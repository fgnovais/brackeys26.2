extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
signal bell_pressed
@onready var label: Label = $Label

func _ready() -> void:
	label.hide()
	
func _on_hover_component_pressed() -> void:
	audio_stream_player.play()
	bell_pressed.emit()


func _on_hover_component_selected(selected) -> void:
	if selected:
		label.show()
	else:
		label.hide()
