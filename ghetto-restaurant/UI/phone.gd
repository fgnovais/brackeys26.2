extends Sprite2D

var menu_scene : PackedScene = load("res://UI/inside_phone.tscn")
var is_menu_spawned : bool = false
signal buy_good
signal buy_bad
signal close
@onready var order: Label = $Order
@onready var hover_component: Node2D = $HoverComponent
signal hide_dialog
func _ready() -> void:
	order.hide()
	
func spawn_menu():
	hide_dialog.emit()
	var menu = menu_scene.instantiate()
	menu.connect("buy_good", good)
	menu.connect("buy_bad", bad)
	menu.connect("close", close_e)
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

func close_e():
	close.emit()
	is_menu_spawned = false

func _on_hover_component_selected(selected: bool) -> void:
	if selected:
		if hover_component.is_enabled:
			order.text = "Order Meat. Wait for dealer."
		else:
			order.text = "Dealer is on the way."
		order.show()
	else:
		order.hide()

func disable():
	hover_component.is_enabled = false
	modulate = Color.DARK_GRAY

func enable():
	hover_component.is_enabled = true
	modulate = Color.WHITE
