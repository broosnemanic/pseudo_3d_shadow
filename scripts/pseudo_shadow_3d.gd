extends Sprite2D
class_name PseudoShadow3D

## Simulates a shadow cast by <sprite> as illumnated by a light source from the z-direction.
## Calculates zoom level but no distortion
## Use: create using PseudoShadow3D.new(); set the Sprite2D which will be casting the shadow (<sprite>),
## Which should usually be the parent of this. Set light_source, which should usually be a child of the Light2D
## actually casting light. Run initialize()

@export var sprite: Sprite2D:					# The sprite that will be casting a shadow
	set(a_sprite):
		sprite = a_sprite
		initialize()

@export var light_source: PseudoNode3D:				# Provides light source location
	set(a_source):
		light_source = a_source
		initialize()

@export var alpha: float:								# How transparent?
	set(a_alpha):
		alpha = a_alpha
		if material != null:
			var t_color: Color = material.get_shader_parameter("color")
			t_color.a = a_alpha
			material.set_shader_parameter("color", t_color)

# Simulated z-distance between obj casting shadow and surface
# shadow is being cast on (e.g. the wall behind the obj)
var shadow_delta_z: float = 50.0:
	set(a_delta):
		shadow_delta_z = a_delta
		recalculate_zoom()
		recalculate_blur()
		
var blur_amount: float:							# How blurry?
	set(a_amount):
		blur_amount = a_amount
		material.set_shader_parameter("blur_amount", blur_amount)

var shadow_shader: Shader = load(SHADOW_SHADER_PATH)
var _zoom: float								# Size of shadow compared to original

const SHADOW_SHADER_PATH: String = "res://shaders/shadow_zoom.gdshader"
const default_z_delta: int = 10					# Count of z-ordering-levels behind parent


func initialize():
	if sprite != null and light_source != null:
		z_index = sprite.z_index - default_z_delta
		texture = sprite.texture
		material = ShaderMaterial.new()
		material.shader = shadow_shader
		material.set_shader_parameter("color", Color.BLACK)
		recalculate_zoom()
		recalculate_blur()


func _process(delta: float) -> void:
	if material != null:
		material.set_shader_parameter("shadow_offset", shadow_offset())
		material.set_shader_parameter("zoom", _zoom)


func shadow_offset() -> Vector2:
	return (shadow_delta_z / light_source.pseudo_position().z) * (light_source.position - sprite.position) + (_zoom - 1) * 0.5 * sprite.texture.get_size()


func recalculate_blur():
	blur_amount = min(5.0, 1.5 * _zoom)


func recalculate_zoom():
	_zoom = (light_source.pseudo_position().z + shadow_delta_z) / light_source.pseudo_position().z
