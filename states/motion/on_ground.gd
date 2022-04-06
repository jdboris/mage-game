extends "motion.gd"

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector3()

export var moving: NodePath

func handle_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.is_pressed() \
	and event.button_index == BUTTON_RIGHT:
		emit_signal("finished", get_node(moving), {
			"target_pos": Global.get_position_at_point_from_camera(event.position)
		})
	
	return .handle_input(event)
