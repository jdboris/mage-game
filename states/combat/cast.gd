extends "res://modules/state.gd"

export var idle: NodePath
export var cast_animation: String

func enter(args := {"spell": {}, "targetPos": Vector2.ZERO}):
	# NOTE: Distance from the camera to the ground
	var cameraZ = sin(Global.cameraPivot.rotation_degrees.x)*Global.camera.translation.z
	var position = Global.camera.project_position(args.targetPos, cameraZ)
	var direction = position - owner.translation
	# NOTE: Ignore y-axis, keep character upright
	direction.y = 0
	owner.look_at(owner.translation - direction, Vector3.UP)
	get_node(animation_player).play(cast_animation)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", get_node(idle), {})
