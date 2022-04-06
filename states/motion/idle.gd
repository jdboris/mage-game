extends "on_ground.gd"

export var idle_animation: String

func enter(args := {}):
	get_node(animation_player).play(idle_animation)


func handle_input(event: InputEvent):
	return .handle_input(event)

