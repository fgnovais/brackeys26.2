extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _on_hover_component_pressed() -> void:
	audio_stream_player.play()
