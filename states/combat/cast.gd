extends "res://modules/state.gd"

export var idle: NodePath
export var cast_animation: String

func enter(args := {"spell": {}, "targetPos": Vector2.ZERO}):
	get_node(animation_player).play(cast_animation)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == cast_animation:
		emit_signal("finished", get_node(idle), {})
