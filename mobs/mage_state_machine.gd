extends "res://components/state_machine.gd"

enum {
	FIRE,
	WATER,
	AIR,
	EARTH
}

var spells: = {
	[FIRE]: "Explosion",
	[WATER]: "Water Beam",
	[AIR]: "Gust",
	[EARTH]: "Boulder",
	[FIRE, FIRE]: "Ignite"
}

var rune_stack: = []

func _change_state(state: NodePath):
	if not _active:
		return
	# if state in [$Stagger, $Jump, $Attack]:
	# 	states_stack.push_front(state)
	# if state == $Jump.get_path() and current_state == $Move:
	# 	$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state)


# NOTE: Only for handling input that can interrupt states (input that states don't handle)
func _unhandled_input(event: InputEvent):
	
	if event.is_action_pressed("fire_rune"):
		rune_stack.push_back(FIRE)
	elif event.is_action_pressed("water_rune"):
		rune_stack.push_back(WATER)
	elif event.is_action_pressed("air_rune"):
		rune_stack.push_back(AIR)
	elif event.is_action_pressed("earth_rune"):
		rune_stack.push_back(EARTH)
	elif event is InputEventMouseButton and \
		event.button_index == BUTTON_LEFT and \
		event.is_pressed():
		
		print("runes: ", rune_stack)
		print(("Casting: " + spells[rune_stack]) if rune_stack in spells else "No spell.")
		if rune_stack in spells:
			$"../../SkeletonWarrior/Health".value -= 10
		
		rune_stack = []

	
