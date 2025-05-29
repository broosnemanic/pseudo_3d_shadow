extends Node2D

var sprite: Sprite2D
@export var light_source: Node2D
var shadow_node: Shadow2D
var light_source_sprite: Sprite2D

func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://shaders/knight_black.png")
	shadow_node = Shadow2D.new()
	add_child(shadow_node)
	shadow_node.sprite = sprite
	shadow_node.light_source = light_source
	shadow_node.initialize()
	shadow_node.position = Vector2(250.0, 250.0)
	light_source_sprite = light_source.get_node("Icon5")

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


func _process(delta: float) -> void:
	var t_secs: float = Time.get_ticks_msec()
	#var t_pos: Vector2 = Vector2(250.0 + 250.0 * (sin(t_secs / 1000.0) - cos(t_secs / 1000.0)), 250.0 + 150.0 * cos(t_secs / 1000.0))
	var t_pos: Vector2 = shadow_node.position + Vector2(250.0 * sin(t_secs / 1000.0), 50.0 * sin(0.5 * PI + t_secs / 500.0))
	light_source.position = t_pos
	#var t_z: float = 200.0 + 50.0 * sin(t_secs / 500.0)
	#shadow_node.light_source_delta_z = t_z
	#light_source_sprite.scale = 0.4 * (t_z / 500.0) * Vector2.ONE
	
