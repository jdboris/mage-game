# Dependencies:
	# AiInput
	# StateMachine
	# FloatProp

extends Area
class_name MobHurtbox

export var _ai_input: NodePath
onready var ai_input: AiInput setget _set_ai_input, _get_ai_input

func _set_ai_input(_value):
	assert(false, "Error: 'ai_input' in " + get_path() + " is readonly.")
func _get_ai_input():
	return get_node(_ai_input)

export var _state_machine: NodePath
onready var state_machine: StateMachine setget _set_state_machine, _get_state_machine

func _set_state_machine(_value):
	assert(false, "Error: 'state_machine' in " + get_path() + " is readonly.")
func _get_state_machine():
	return get_node(_state_machine)

# ##############################################################################
# Mobs:
# ##############################################################################

export var _mob_health: NodePath
onready var mob_health: FloatProp = get_node(_mob_health)
