extends "res://modules/state.gd"

export var idle: NodePath
export var cast_animation: String

func enter():
	get_node(animation_player).play(cast_animation)


func _on_cast_finished():
	emit_signal("finished", idle)
