extends KinematicBody
class_name Mob

export var speed: = 8.0
var velocity: = Vector3.ZERO

func look_model_at(direction: Vector3):
	$Pivot.look_at(translation + direction, Vector3.UP)

func _physics_process(delta: float) -> void:
	if velocity:
		$Pivot/Mage/AnimationPlayer.playback_speed = 2
		$Pivot/Mage/AnimationPlayer.current_animation = "Walk"
	else:
		$Pivot/Mage/AnimationPlayer.current_animation = "Idle"
