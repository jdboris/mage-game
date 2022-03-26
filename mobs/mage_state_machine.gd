extends "res://modules/state_machine.gd"

export var cast: NodePath

enum {
	FIRE,
	WATER,
	AIR,
	EARTH
}

export var spells: = {
	[FIRE]: { 
		"name": "Explosion",
		"castTime": 0.4,
		"damage": 10, 
		"effect": preload("res://effects/explosion_1.tscn")
	},
	[WATER]: { "name": "Water Beam", "damage": 10, "effect": NodePath() },
	[AIR]: { "name": "Gust", "damage": 10, "effect": NodePath() },
	[EARTH]: { "name": "Boulder", "damage": 10, "effect": NodePath() },
	[FIRE, FIRE]: { "name": "Ignite", "damage": 20, "effect": NodePath() },
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
		
		if rune_stack in spells:
			_change_state(get_node(cast), {
				"spell": spells[rune_stack], 
				"targetPos": mouseEvent.position
			})
		
		rune_stack = []
