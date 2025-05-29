@tool
extends Node2D
class_name Shadow2D

@export var sprite: Sprite2D:					# The sprite that will be casting a shadow
	set(a_sprite):
		sprite = a_sprite
		update_configuration_warnings()
		
@export var light_source: Node2D:				# Provides light source location
	set(a_source):
		light_source = a_source
		update_configuration_warnings()
		
var _shadow_sprite: Sprite2D					# Internally generated copy of <sprite>
												# Generates shadow on different z
@onready var shadow_shader: Shader = preload("res://shaders/shadow_zoom.gdshader")

var light_source_delta_z: float = 100.0:		# Simulated z-distance between light_source and sprite
	set(a_delta):
		light_source_delta_z = a_delta
		recalculate_zoom()
		recalculate_blur()
		
var shadow_delta_z: float = 50.0:				# Simulated z-distance between sprite and shadow
	set(a_delta):
		shadow_delta_z = a_delta
		recalculate_zoom()
		recalculate_blur()
		
var zoom: float									# Size of shadow comapred to original
var blur_amount: float:							# How blurry?
	set(a_amount):
		blur_amount = a_amount
		_shadow_sprite.material.set_shader_parameter("blur_amount", blur_amount)

var alpha: float:								# How transparent?
	set(a_alpha):
		alpha = a_alpha
		var t_color: Color = _shadow_sprite.material.get_shader_parameter("color")
		t_color.a = a_alpha
		_shadow_sprite.material.set_shader_parameter("color", t_color)


func initialize():
	_shadow_sprite = sprite.duplicate()
	_shadow_sprite.material = ShaderMaterial.new()
	_shadow_sprite.material.shader = shadow_shader
	_shadow_sprite.material.set_shader_parameter("color", Color.BLACK)
	add_child(sprite)
	add_child(_shadow_sprite)
	recalculate_zoom()
	recalculate_blur()


func _process(delta: float) -> void:
	_shadow_sprite.material.set_shader_parameter("shadow_offset", shadow_offset())
	#print("shadow_ofset: " + str(shadow_offset()))
	_shadow_sprite.material.set_shader_parameter("zoom", zoom)
	#print("zoom: " + str(zoom))


func shadow_offset() -> Vector2:
	#return zoom * (light_source.position - position) + (zoom - 1) * 0.5 * sprite.texture.get_size()
	return (shadow_delta_z / light_source_delta_z) * (light_source.position - position) + (zoom - 1) * 0.5 * sprite.texture.get_size()


func recalculate_blur():
	blur_amount = min(5.0, 1.5 * zoom)
	

func _get_configuration_warnings():
	if sprite == null:
		return ["Requires a sprite: Sprite2D"]
	if light_source == null:
		return ["Requires a light_source: Node2D"]
		

func recalculate_zoom():
	zoom = (light_source_delta_z + shadow_delta_z) / light_source_delta_z
