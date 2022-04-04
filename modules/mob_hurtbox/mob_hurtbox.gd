# Dependencies:
	# StateMachine
	# FloatProp

extends Area
class_name MobHurtbox

export var _mob_health: NodePath
onready var mob_health: FloatProp = get_node(_mob_health)

export var _state_machine: NodePath
onready var state_machine: StateMachine setget _set_state_machine, _get_state_machine

func _set_state_machine(_value):
	assert(false, "Error: 'state_machine' in " + get_path() + " is readonly.")

func _get_state_machine():
	return get_node(_state_machine)
