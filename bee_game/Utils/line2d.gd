extends Line2D

var this :PackedScene = load("res://Utils/line_2d.tscn")
var held: bool = false
var frozen : bool = false 
@onready var timer: Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delta_add :float = 0
func _process(delta: float) -> void:
	if frozen != true:
		delta_add += delta
		
		if delta_add > 0.01 and held:
			delta_add = 0
			var pos : Vector2 = get_local_mouse_position()
			add_point(pos)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse1"):
		held = true
		#timer.start()
	if event.is_action_released("mouse1"):
		if !frozen:
			held = false
			var old = this.instantiate()
			old.points = points
			old.frozen = true
			add_child(old)
			old.timer.start()
			clear_points()

func _on_timer_timeout() -> void:
	queue_free()
