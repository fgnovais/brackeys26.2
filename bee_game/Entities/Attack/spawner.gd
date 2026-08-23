extends Node2D

var attack_scene : PackedScene = preload("res://Entities/Attack/attack.tscn")
@onready var positions: Node2D = $Positions
signal player_was_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_attack()

func _on_timer_timeout() -> void:
	spawn_attack()

func spawn_attack():
	var attack = attack_scene.instantiate()
	attack.connect("attack_hit", attack_hit)
	var pos : Marker2D = positions.get_children().pick_random()
	attack.position = pos.position
	add_child(attack)

func attack_hit():
	player_was_hit.emit()
