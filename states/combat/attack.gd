extends "res://modules/state_machine/state.gd"

export var damage: = 10
export var attack_animation: String

func _ready() -> void:
	is_reversible = true

func enter(args := {"target": MobHurtbox}):
	(get_node(animation_player) as AnimationPlayer).play(attack_animation)
	args.target.mob_health.value -= damage

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == attack_animation:
		emit_signal("finished", null, {})
