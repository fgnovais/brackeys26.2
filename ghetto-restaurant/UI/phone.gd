extends Sprite2D

var menu_scene : PackedScene = load("res://UI/inside_phone.tscn")
var is_menu_spawned : bool = false
signal buy_good
signal buy_bad
@onready var order: Label = $Order
signal hide_dialog
func _ready() -> void:
	order.hide()
	
func spawn_menu():
	hide_dialog.emit()
	var menu = menu_scene.instantiate()
	menu.connect("buy_good", good)
	menu.connect("buy_bad", bad)
	add_child(menu)

func despawn_menu():
	get_child(-1).queue_free()

func _on_hover_component_pressed() -> void:
	if !is_menu_spawned:
		spawn_menu()
		is_menu_spawned = true

func good():
	buy_good.emit()
	is_menu_spawned = false
	
func bad():
	buy_bad.emit()
	is_menu_spawned = false

func _on_hover_component_selected(selected: bool) -> void:
	if selected:
		order.show()
	else:
		order.hide()
