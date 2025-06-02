@tool
extends Sprite2D
class_name PseudoShadow3D

@export var sprite: Sprite2D:					# The sprite that will be casting a shadow
	set(a_sprite):
		sprite = a_sprite
		initialize()
		update_configuration_warnings()
		
@export var light_source: PseudoNode3D:				# Provides light source location
	set(a_source):
		light_source = a_source
		initialize()
		update_configuration_warnings()

var shadow_shader: Shader = load("res://shaders/shadow_zoom.gdshader")

# Simulated z-distance between obj casting shadow and surface
# shadow is being cast on (e.g. the wall behind the obj)
var shadow_delta_z: float = 50.0:
	set(a_delta):
		shadow_delta_z = a_delta
		recalculate_zoom()
		recalculate_blur()
		
var zoom: float									# Size of shadow comapred to original
var blur_amount: float:							# How blurry?
	set(a_amount):
		blur_amount = a_amount
		material.set_shader_parameter("blur_amount", blur_amount)

var alpha: float:								# How transparent?
	set(a_alpha):
		alpha = a_alpha
		var t_color: Color = material.get_shader_parameter("color")
		t_color.a = a_alpha
		material.set_shader_parameter("color", t_color)




func initialize():
	if sprite != null and light_source != null:
		
		z_index = sprite.z_index - 10
		texture = sprite.texture
		material = ShaderMaterial.new()
		material.shader = shadow_shader
		material.set_shader_parameter("color", Color.BLACK)
		recalculate_zoom()
		recalculate_blur()


func _process(delta: float) -> void:
	material.set_shader_parameter("shadow_offset", shadow_offset())
	#print("shadow_ofset: " + str(shadow_offset()))
	material.set_shader_parameter("zoom", zoom)
	#print("zoom: " + str(zoom))


func shadow_offset() -> Vector2:
	#return zoom * (light_source.position - position) + (zoom - 1) * 0.5 * sprite.texture.get_size()
	#return (shadow_delta_z / light_source_delta_z) * (light_source.position - position) + (zoom - 1) * 0.5 * sprite.texture.get_size()
	return (shadow_delta_z / light_source.pseudo_position().z) * (light_source.position - sprite.position) + (zoom - 1) * 0.5 * sprite.texture.get_size()


func recalculate_blur():
	blur_amount = min(5.0, 1.5 * zoom)
	

func _get_configuration_warnings():
	if sprite == null:
		return ["Requires a sprite: Sprite2D"]
	if light_source == null:
		return ["Requires a light_source: Node2D"]
		

func recalculate_zoom():
	#zoom = (light_source_delta_z + shadow_delta_z) / light_source_delta_z
	zoom = (light_source.pseudo_position().z + shadow_delta_z) / light_source.pseudo_position().z
