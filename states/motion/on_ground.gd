extends "motion.gd"

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector3()

export var moving: NodePath

func handle_input(event: InputEvent):
	if event.is_action_pressed("move_to"):
		emit_signal("finished", get_node(moving), {
			"target_pos": Global.get_3d_position_at_point(event.position)
		})
	
	return .handle_input(event)
