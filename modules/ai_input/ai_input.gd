extends Node
class_name AiInput

signal input(event)

#var actions: = init_actions()
#
#func init_actions() -> Dictionary:
#	var actions = {}
#	for name in InputMap.get_actions():
#		actions[name] = new_action(name)
#	return actions
#
#func new_action(name: String, is_pressed: bool = false, strength: float = 0.0) -> InputEventAction:
#	var action: = CustomEvent.new()
#	action.action = name
#	action.pressed = is_pressed
#	action.strength = strength
#	return action

#func press_actions(strengthsByName: Dictionary):
#	for name in strengthsByName:
#		press_action(name, strengthsByName[name])
#
#func press_action(action: String, strength: float):
#	actions[action].pressed = strength > 0
#	actions[action].strength = strength

#func get_action_strength(action: String):
#	if action in actions:
#		return actions[action].strength
#	else:
#		return 0
