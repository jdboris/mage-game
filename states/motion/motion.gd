extends "res://modules/state_machine/state.gd"
class_name MotionState

onready var target_pos: Vector3 = owner.global_transform.origin

func handle_input(_event: InputEvent):
#	if event.is_action_pressed("simulate_damage"):
#		emit_signal("finished", get_node(stagger), {})
	pass

func get_input_direction():
	
#	return Vector3(
#		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
#		0,
#		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
#	)
	
	return owner.global_transform.origin.direction_to(target_pos)

func update_look_direction(direction: Vector3):
	if direction:
		owner.look_at(owner.translation - direction, Vector3.UP)
