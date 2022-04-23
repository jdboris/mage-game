# Dependencies:
# AiInput
# StateMachine
# FloatProp

extends Area
class_name MobHurtbox

# Optional
export var _ai_input: NodePath
onready var ai_input: AiInput setget _set_ai_input, _get_ai_input


func _set_ai_input(_value):
	assert(false, "Error: 'ai_input' in " + get_path() + " is readonly.")


func _get_ai_input():
	return get_node(_ai_input)


export(NodePath) onready var state_machine = get_node(state_machine) as StateMachine setget _set_state_machine


func _set_state_machine(_value):
	if state_machine:
		assert(false, "Error: 'state_machine' in " + get_path() + " is readonly.")
	else:
		state_machine = _value


# ##############################################################################
# Mobs:
# ##############################################################################

export(NodePath) onready var mob_health = get_node(mob_health) as FloatProp
