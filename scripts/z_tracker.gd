extends Node2D
class_name ZTracker

## For use by Shadow2D nodes to calculate shadows in fake 3D ##
## This node should be parented to a node which represents a light source ##

var pseudo_z: float				# Z coordinate we are pretending exists
var is_use_global_pos: bool		# If true, pseudo_pos will be calulated using global_position


# For convenience
func _init(a_pseudo_z: float) -> void:
	pseudo_z = a_pseudo_z


# Constructed fake xyz position
func pseudo_pos() -> Vector3:
	if is_use_global_pos:
		return Vector3(global_position.x, global_position.y, pseudo_z)
	else:
		return get_parent().position + Vector3(0.0, 0.0, pseudo_z)
