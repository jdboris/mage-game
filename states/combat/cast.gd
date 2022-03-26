extends "res://modules/state.gd"

export var idle: NodePath
export var cast_animation: String

func enter(args := {"spell": {}, "targetPos": Vector2.ZERO}):
	# NOTE: Distance from the camera to the ground
	var cameraZ = sin(Global.cameraPivot.rotation_degrees.x)*Global.camera.translation.z
	
	var position = Global.get_position_at_point_from_camera(args.targetPos)
	var direction = position - owner.translation
	owner.look_at(owner.translation - direction, Vector3.UP)
	(get_node(animation_player) as AnimationPlayer).play(cast_animation, -1, 1 / args.spell.castTime)
	
	var effect: Area = (args.spell.effect as PackedScene).instance()
	effect.translation = position
	Global.level.add_child(effect)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", get_node(idle), {})
