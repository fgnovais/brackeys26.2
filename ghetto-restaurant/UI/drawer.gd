extends Sprite2D

var menu_scene : PackedScene = load("res://UI/inside_drawer.tscn")
var is_menu_spawned : bool = false
var item_scene : PackedScene = load("res://UI/item_icon.tscn")

func spawn_menu():
	var menu : InsideDrawer = menu_scene.instantiate()
	menu.connect("killed", menu_was_despawned)
	add_child(menu)
	add_items_to_drawer(menu)

func despawn_menu():
	get_child(-1).queue_free()

func _on_hover_component_pressed() -> void:
	if !is_menu_spawned:
		spawn_menu()
		is_menu_spawned = true

func menu_was_despawned():
	is_menu_spawned = false
	
func add_items_to_drawer(menu : InsideDrawer):
	for item_resource in ItemManager.current_items:
		var item : ItemIcon = item_scene.instantiate()
		item.item = item_resource
		
		menu.fill(item)
