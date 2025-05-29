extends Node2D

var sprite: Sprite2D
@export var light_source: Node2D
var shadow_node: Shadow2D

func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://shaders/knight_black.png")
	shadow_node = Shadow2D.new()
	add_child(shadow_node)
	shadow_node.sprite = sprite
	shadow_node.light_source = light_source
	shadow_node.initialize()
	shadow_node.position = Vector2(250.0, 250.0)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_W:
			light_source.position += Vector2(0.0, -10.0)
		if event.keycode == KEY_A:
			light_source.position += Vector2(-10.0, 0.0)
		if event.keycode == KEY_S:
			light_source.position += Vector2(0.0, 10.0)
		if event.keycode == KEY_D:
			light_source.position += Vector2(10.0, 0.0)
		if event.keycode == KEY_Z:
				shadow_node.alpha = 0.5
