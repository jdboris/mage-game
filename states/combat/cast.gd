extends "res://modules/state_machine/state.gd"

export var idle: NodePath
export var cast_animation: String

func enter(args := {"spell": {}, "targetPos": Vector2.ZERO}):
	var position = Global.get_position_at_point_from_camera(args.targetPos)
	var direction = position - owner.translation
	owner.look_at(owner.translation - direction, Vector3.UP)
	
	args.spell.cast({"target": position})

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", get_node(idle), {})
