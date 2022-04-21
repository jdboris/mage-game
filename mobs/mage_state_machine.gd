extends "res://modules/state_machine/state_machine.gd"

export var moving: NodePath
export var casting: NodePath
var casting_cursor := preload("res://ui/casting_cursor.tscn")

enum { FIRE, WATER, AIR, EARTH }

export var spells := {
	[FIRE]: NodePath(),  # "Casting/Explosion"
	[WATER]: NodePath(),  # "Casting/WaterBeam"
	#	[AIR]: NodePath(),
	[EARTH]: NodePath(), # "Casting/Boulder"
	#	[FIRE, FIRE]: NodePath(),
}

var rune_stack := []
var commands := preload("res://modules/command_queue/command_queue.gd").new()


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
	elif event.is_action_pressed("cast_at"):
		var mouse_event := event as InputEventMouseButton
		if rune_stack in spells:
			var spell = get_node(spells[rune_stack])
			assert(
				spell,
				(
					"Error: spell ('"
					+ spells[rune_stack]
					+ "') with run stack ('"
					+ String(rune_stack)
					+ "') not found in '"
					+ get_path()
					+ "'. Is it plugged in?"
				)
			)
			cast_spell(spell, mouse_event.position)
		
		# TODO: Do this right
#		if MouseCursor.cursor is casting_cursor:
		if MouseCursor.cursor:
			MouseCursor.set_mouse_cursor(null)
		rune_stack = []
	
	if rune_stack.size():
		# TODO: Do this right
#		if MouseCursor.cursor is casting_cursor:
		if not MouseCursor.cursor:
			MouseCursor.set_mouse_cursor(casting_cursor)


func cast_spell(spell, target_pos: Vector2):
	
	if commands.queue.size() > 1:
		return false
	
	var cast_time_left = current_state.time_left if current_state == get_node(casting) else 0
	
	if cast_time_left or spell.cooldown_timer.time_left:
		if cast_time_left > 0.5 or spell.cooldown_timer.time_left > 0.5:
			return false
		
		if cast_time_left > spell.cooldown_timer.time_left:
			yield(current_state, "finished")
		else:
			yield(spell.cooldown_timer, "timeout")
	
	
	var command := commands.new_command()
	
	# NOTE: only yield conditionally, to keep the first command synchronous
	if command.previous:
		yield(command.previous, "completed")
	
	_change_state(get_node(casting), {"spell": spell, "target_pos": target_pos})
	
	# NOTE: It's possible that the state has already changed again (in the enter() method)
	if current_state == get_node(casting):
		yield(get_node(casting), "finished")
	
	command.end()
