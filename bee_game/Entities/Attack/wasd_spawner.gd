extends Node2D

var attack_scene : PackedScene = preload("res://Entities/Attack/wasd_attack.tscn")
@onready var positions: Node2D = $Positions
signal player_was_hit
const A = preload("uid://bwyilt5tvq0ml")
const D = preload("uid://22kqhrtrfdgd")
const S = preload("uid://nwvqsug0qfaa")
const W = preload("uid://cmt62xpso3kiq")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_attack()

func _on_timer_timeout() -> void:
	spawn_attack()

func spawn_attack():
	var attack = attack_scene.instantiate()
	attack.connect("attack_destroyed", attack_destroyed)
	var pos : Marker2D = positions.get_children().pick_random()
	attack.position = pos.position
	attack.key = ["s","d","w","a"].pick_random()
	#attack.key = "a"
	add_child(attack)
	match attack.key:
		"s":
			attack.sprite_2d.texture = S
		"a":
			attack.sprite_2d.texture = A
		"w":
			attack.sprite_2d.texture = W
		"d":
			attack.sprite_2d.texture = D

func attack_destroyed(key: String):
	for child in get_children():
		if child is WasdAttack:
			if child.key == key:
				child.queue_free()
				return
	player_was_hit.emit()

func _input(event: InputEvent) -> void:
	if !event.is_echo():
		if event.is_action_pressed("left"):
			attack_destroyed("a")
		elif event.is_action_pressed("right"):
			attack_destroyed("d")
		elif event.is_action_pressed("up"):
			attack_destroyed("w" )
		elif event.is_action_pressed("down"):
			attack_destroyed("s")
