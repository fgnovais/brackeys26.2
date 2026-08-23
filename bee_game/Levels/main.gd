extends Node2D

@onready var player: Player = $Player
@onready var player_hp: Label = $PlayerHP
@onready var game_over: CanvasLayer = $GameOver

func _on_player_was_hit() -> void:
	player.hit()
	player_hp.text = str(player.health)
	
	if player.health <= 0:
		show_game_over()
		
func show_game_over() :
	game_over.show()
	Engine.time_scale = 0
		
