extends "on_ground.gd"

export var idle_animation: String

func enter(args := {}):
	animation_player.play(idle_animation)


func handle_input(event: InputEvent):
	return .handle_input(event)

