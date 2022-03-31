extends "res://modules/state_machine/state_machine.gd"

export var dead: NodePath

func _change_state(state: Node, args := {}):
	if not _active:
		return
	# if state in [$Stagger, $Jump, $Attack]:
	# 	states_stack.push_front(state)
	# if state == $Jump.get_path() and current_state == $Move:
	# 	$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state, args)


# NOTE: Only for handling input that can interrupt states (input that states don't handle)
func _unhandled_input(event):
#	if event.is_action_pressed("attack"):
#		if current_state in [$Attack, $Stagger]:
#			return
#		_change_state($Attack.get_path(), {})
#		return
	current_state.handle_input(event)


func _on_Health_value_changed(old_value, prop) -> void:
	if prop.value <= 0:
		_change_state(get_node(dead))
