extends "res://modules/state_machine/state_machine.gd"

export var casting: NodePath

enum {
	FIRE,
	WATER,
	AIR,
	EARTH
}

export var spells: = {
	[FIRE]: NodePath(), # "Cast/Explosion"
	[WATER]: NodePath(),
	[AIR]: NodePath(),
	[EARTH]: NodePath(),
	[FIRE, FIRE]: NodePath(),
}

var rune_stack: = []
var commands: = preload("res://modules/command_queue/command_queue.gd").new()

func _change_state(state: Node = null, args := {}):
	
	if not _active:
		return
#	if current_state in [$Casting] and not state in [$Idle]:
#		return
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
			var spell = get_node(spells[rune_stack])
			assert(spell, "Error: spell ('" + spells[rune_stack] + "') not found in '" + get_path() + "'. Is it plugged in?")
			cast_spell(spell, mouseEvent.position)
		
		rune_stack = []

func cast_spell(spell, targetPos: Vector2):
	
	var command: = commands.new_command()
	# NOTE: only yield conditionally, to keep the first command synchronous
	if command.previous: yield(command.previous, "completed")
	
	_change_state(get_node(casting), {
		"spell": spell, 
		"targetPos": targetPos
	})
	
	yield(get_node(casting), "finished")
	command.end()
