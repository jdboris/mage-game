extends "res://modules/state.gd"

export var dead: NodePath


# Initialize the state. E.g. change the animation.
func enter(args := {}):
	owner.set_dead(true)
	get_node(animation_player).play("die")


func _on_animation_finished(_anim_name):
	emit_signal("finished", get_node(dead))
