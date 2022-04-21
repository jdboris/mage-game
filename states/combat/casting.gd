extends "res://modules/state_machine/state.gd"

var cast_animation: String
var time_left: float setget , _get_time_left

func _ready() -> void:
	is_reversible = true


func enter(args := {"spell": {}, "target_pos": Vector2.ZERO}):
	var position = Global.get_3d_position_at_point(args.target_pos)
	var direction = position - owner.global_transform.origin
	owner.look_at(owner.global_transform.origin - direction, Vector3.UP)
	cast_animation = args.spell.cast_animation

	if args.spell.cast({"target": position}) == false:
		emit_signal("finished", null, {})


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", null, {})

func _get_time_left():
	var player := (get_node(animation_player) as AnimationPlayer)
	return player.current_animation_length - player.current_animation_position
