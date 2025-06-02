extends Node2D

var sprite: Sprite2D
@onready var light_source: PseudoNode3D = %LightSource
@onready var light_source_2: PseudoNode3D = %LightSource2
@onready var knight_sprite: Sprite2D = %Knight
@onready var cat_sprite: Sprite2D = %Cat
@onready var center: Vector2 = Vector2(500.0, 200.0)


func _ready() -> void:
	light_source.pseudo_z = 200.0
	light_source_2.pseudo_z = 500.0
	add_shadow(knight_sprite, light_source)
	add_shadow(cat_sprite, light_source)
	add_shadow(knight_sprite, light_source_2)
	add_shadow(cat_sprite, light_source_2)


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


func _process(delta: float) -> void:
	var t_secs: float = Time.get_ticks_msec()
	light_source.position = center + Vector2(250.0 * sin(t_secs / 1000.0), 50.0 * sin(0.5 * PI + t_secs / 500.0))
	light_source_2.position = center + Vector2(100.0, 100.0) + Vector2(250.0 * sin(t_secs / 1000.0), 0.0)
	light_source.get_node("Torch").scale = Vector2(sqrt(light_source.pseudo_z / 2000.0), sqrt(light_source.pseudo_z / 2000.0))
	light_source_2.get_node("Torch").scale = Vector2(sqrt(light_source_2.pseudo_z / 2000.0), sqrt(light_source_2.pseudo_z / 2000.0))
	

func add_shadow(a_sprite: Sprite2D, a_source: PseudoNode3D):
	var t_shadow: PseudoShadow3D = PseudoShadow3D.new()
	t_shadow.sprite = a_sprite
	t_shadow.light_source = a_source
	t_shadow.alpha = 0.5
	a_sprite.add_child(t_shadow)
