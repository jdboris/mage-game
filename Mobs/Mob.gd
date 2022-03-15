extends KinematicBody
class_name Mob

export var speed: = 14.0
var velocity: = Vector3.ZERO

func look_model_at(direction: Vector3):
	$Pivot.look_at(translation + direction, Vector3.UP)
