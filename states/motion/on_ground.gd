extends "motion.gd"

export var jump: NodePath

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector3()


func handle_input(event: InputEvent):
#	if event.is_action_pressed("jump"):
#		emit_signal("finished", get_node(jump), {})
	return .handle_input(event)
