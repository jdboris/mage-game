extends "res://modules/state.gd"

# Methods to handle direction and animation.

#export var stagger: NodePath

func handle_input(_event: InputEvent):
#	if event.is_action_pressed("simulate_damage"):
#		emit_signal("finished", stagger)
	pass

func get_input_direction():
	
	var input_direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	return input_direction

func update_look_direction(direction: Vector3):
	if direction:
		owner.look_at(owner.translation - direction, Vector3.UP)
