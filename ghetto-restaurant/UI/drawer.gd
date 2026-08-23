extends Sprite2D

var menu_scene : PackedScene = load("res://UI/drawer.tscn")
var is_menu_spawned : bool = false

func spawn_menu():
	var menu = menu_scene.instantiate()
	menu.connect("killed", menu_was_despawned)
	add_child(menu)

func despawn_menu():
	get_child(-1).queue_free()

func _on_hover_component_pressed() -> void:
	if !is_menu_spawned:
		spawn_menu()
		is_menu_spawned = true

func menu_was_despawned():
	is_menu_spawned = false
	
