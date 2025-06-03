@tool
extends Node2D
class_name PseudoNode3D

## Node2D with pretend z-position; for keeping track of light source position when ##
## simulating 3D-ish shadows ##


var pseudo_z: float							# Fake z position

func pseudo_position() -> Vector3:			# Real x, y, and fake z
	return Vector3(position.x, position.y, pseudo_z)
