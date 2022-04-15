extends "res://modules/state_machine/state.gd"

var cast_animation: String

func _ready() -> void:
	is_reversible = true

func enter(args := {"spell": {}, "target_pos": Vector2.ZERO}):
	var position = Global.get_3d_position_at_point(args.target_pos)
	var direction = position - owner.translation
	owner.look_at(owner.translation - direction, Vector3.UP)
	cast_animation = args.spell.cast_animation
	
	args.spell.cast({"target": position})

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", null, {})
