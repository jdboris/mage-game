extends Node
class_name AiInput

var target: KinematicBody
var actions: = init_actions()

func init_actions() -> Dictionary:
	var actions = {}
	for name in InputMap.get_actions():
		actions[name] = new_action(name)
	return actions

func new_action(name: String, is_pressed: bool = false, strength: float = 0.0) -> InputEventAction:
	var action: = InputEventAction.new()
	action.action = name
	action.pressed = is_pressed
	action.strength = strength
	return action

func press_actions(strengthsByName: Dictionary):
	for name in strengthsByName:
		press_action(name, strengthsByName[name])

func press_action(action: String, strength: float):
	actions[action].pressed = strength > 0
	actions[action].strength = strength

func get_action_strength(action: String):
	if action in actions:
		return actions[action].strength
	else:
		return 0

func move_mob_towards_target(mob: KinematicBody, target: KinematicBody):
	
	var direction = mob.global_transform.origin.direction_to(target.global_transform.origin) if target else Vector3.ZERO
	press_actions({
		"move_left": abs(direction.x) if direction.x < 0 else 0,
		"move_right": abs(direction.x) if direction.x > 0 else 0,
		"move_forward": abs(direction.z) if direction.z < 0 else 0,
		"move_back": abs(direction.z) if direction.z > 0 else 0
	})

func set_target(mob: KinematicBody):
	target = target if target else mob