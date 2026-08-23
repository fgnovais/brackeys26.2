extends Node2D
class_name WasdAttack

signal attack_hit
signal attack_destroyed
var key : String 
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center = get_viewport_rect().size / 2
	position = position.move_toward(center, delta*50)
	#if position == center:
		#queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	attack_hit.emit()
	queue_free()
