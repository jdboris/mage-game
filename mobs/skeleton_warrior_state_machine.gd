extends "res://modules/state_machine/state_machine.gd"

var target: KinematicBody

export(NodePath) onready var dead = get_node(dead) as Node
export(NodePath) onready var attack = get_node(attack) as Node
export(NodePath) onready var audio_looper = get_node(audio_looper) as AudioStreamPlayer


func _change_state(state: Node = null, args := {}):
	if not _active:
		return
	if state in [dead]:
		audio_looper.stream_paused = true
	elif !audio_looper.is_playing():
		audio_looper.stream_paused = false
	._change_state(state, args)


# NOTE: Only for handling input that can interrupt states (input that states don't handle)
func _unhandled_input(event):
	if current_state in [dead]:
		return

	if event.is_action_pressed("attack"):
		if current_state in [attack]:
			return
		_change_state(attack, {"target": event.target})
		return
	current_state.handle_input(event)


func _on_Health_value_changed(old_value, prop) -> void:
	if prop.value <= 0 and current_state != dead:
		_change_state(dead)
