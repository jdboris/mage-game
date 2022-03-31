extends "res://modules/state_machine/state.gd"

export var death_animation: String
export var dead_animation: String

func enter(args := {}):
	
	if death_animation:
		get_node(animation_player).play(death_animation)
	elif dead_animation:
		get_node(animation_player).play(dead_animation)

func _on_animation_finished(_anim_name):
	if _anim_name == death_animation:
		get_node(animation_player).play(dead_animation)
