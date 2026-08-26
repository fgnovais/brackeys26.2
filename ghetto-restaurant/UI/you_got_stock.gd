extends Control

@onready var meat: TextureRect = $Meat
signal stock_accepted
var is_good_meat: bool = true
var bad_meat_texture : Texture2D = load("res://UI/bad_meat.png")
var good_meat_texture : Texture2D = load("res://UI/good_meat.png")

func _ready() -> void:
	if is_good_meat:
		meat.texture = good_meat_texture
	else:
		meat.texture = bad_meat_texture
		
func _on_accept() -> void:
	stock_accepted.emit(is_good_meat)
	queue_free()
