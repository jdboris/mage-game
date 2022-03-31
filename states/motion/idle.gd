extends "on_ground.gd"

export var idle_animation: String

export var moving: NodePath

func enter(args := {}):
	get_node(animation_player).play(idle_animation)


func handle_input(event: InputEvent):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", get_node(moving), {})
