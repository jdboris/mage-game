extends Node

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

func press_action(action: String, strength: float):
	actions[action].pressed = strength > 0
	actions[action].strength = strength

func get_action_strength(action: String):
	if action in actions:
		return actions[action].strength
	else:
		return 0

func _process(_delta: float):
	var mob = (owner as KinematicBody)
	var mage = (get_node("../../Mage") as KinematicBody)
	
	var distance = mob.global_transform.origin.distance_to(mage.global_transform.origin)
	if distance <= 8:
		target = mage
	elif distance > 14:
		target = null
	
	var direction = mob.global_transform.origin.direction_to(target.global_transform.origin) if target else Vector3.ZERO
	press_action("move_left", abs(direction.x) if direction.x < 0 else 0)
	press_action("move_right", abs(direction.x) if direction.x > 0 else 0)
	press_action("move_forward", abs(direction.z) if direction.z < 0 else 0)
	press_action("move_back", abs(direction.z) if direction.z > 0 else 0)
	
