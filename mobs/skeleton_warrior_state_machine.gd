extends "res://modules/state_machine/state_machine.gd"

var target: KinematicBody

export var dead: NodePath
export var attack: NodePath

func _change_state(state: Node = null, args := {}):
	if not _active:
		return
	# if state in [$Stagger, $Jump, $Attack]:
	# 	states_stack.push_front(state)
	# if state == $Jump.get_path() and current_state == $Move:
	# 	$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state, args)


# NOTE: Only for handling input that can interrupt states (input that states don't handle)
func _unhandled_input(event):
	if current_state in [get_node(dead)]:
		return
	
	if event.is_action_pressed("attack"):
		if current_state in [get_node(attack)]:
			return
		_change_state(get_node(attack), {"target": event.target})
		return
	current_state.handle_input(event)


func _on_Health_value_changed(old_value, prop) -> void:
	if prop.value <= 0 and current_state != get_node(dead):
		_change_state(get_node(dead))
