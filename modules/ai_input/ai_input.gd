extends Node
class_name AiInput

class CustomEvent extends InputEventAction:
	var position: Vector2
	
	func _init() -> void:
		pressed = true
		strength = 1

signal input(event)

var target: KinematicBody

func move_mob_towards_target(mob: KinematicBody, target: KinematicBody):
	var event = Global.init_object( 
		CustomEvent.new(), {
			"action": "move_to",
			"position": Global.get_2d_position_at_point(target.global_transform.origin)
		}
	)
	
	emit_signal("input", event)

func set_target(mob: KinematicBody):
	target = target if target else mob


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
