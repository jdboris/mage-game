extends "res://modules/state_machine.gd"

export var cast: NodePath

enum {
	FIRE,
	WATER,
	AIR,
	EARTH
}

var spells: = {
	[FIRE]: { "name": "Explosion", "damage": 10 },
	[WATER]: { "name": "Water Beam", "damage": 10 },
	[AIR]: { "name": "Gust", "damage": 10 },
	[EARTH]: { "name": "Boulder", "damage": 10 },
	[FIRE, FIRE]: { "name": "Ignite", "damage": 20 },
}

var rune_stack: = []

func _change_state(state: Node, args := {}):
	if not _active:
		return
	if current_state in [$Cast] and not state in [$Idle]:
		return
	# if state in [$Stagger, $Jump, $Attack]:
	# 	states_stack.push_front(state)
	# if state == $Jump and current_state == $Move:
	# 	$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state, args)


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
		var mouseEvent := (event as InputEventMouseButton)
		
		print("runes: ", rune_stack)
		print(("Casting: " + spells[rune_stack].name) if rune_stack in spells else "No spell.")
		print("pos: ", mouseEvent.position)
		if rune_stack in spells:
			_change_state(get_node(cast), {
				"spell": spells[rune_stack], 
				"targetPos": mouseEvent.position
			})
#			(get_node(animation_player) as AnimationPlayer).play(cast_animation)
#			$"../../SkeletonWarrior/Health".value -= spells[rune_stack].damage
		
		rune_stack = []
