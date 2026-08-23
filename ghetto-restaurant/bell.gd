extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_hover_component_selected(is_selected: bool) -> void:
	if is_selected:
		audio_stream_player.play()
