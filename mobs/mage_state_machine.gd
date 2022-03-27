extends "res://modules/state_machine.gd"

export var cast: NodePath

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
			var spell = get_node(spells[rune_stack])
			assert(spell, "Error: spell ('" + spells[rune_stack] + "') not found in '" + get_path() + "'. Is it plugged in?")
			cast_spell(spell, mouseEvent.position)
		
		rune_stack = []


var _promises := []


func queue_command(object: Object, complete_signal: String) -> GDScriptFunctionState:
	var previous = _promises.back()
	var root = _empty_promise()
	_promise_command(root, object, complete_signal)
	_push_promise(root)
	
	return previous

func _promise_command(root, object: Object, complete_signal: String):
	if _promises.size():
		yield(_promises.back(), "completed")
	
	yield(object, complete_signal)
	
	root.resume()

func _push_promise(promise: GDScriptFunctionState) -> GDScriptFunctionState:
	_promises.push_back(promise)
	promise.connect("completed", self, "_pop_promise")
	return promise

func _pop_promise():
	return _promises.pop_front()

func _empty_promise():
	yield()

func cast_spell(spell, targetPos: Vector2):
	var previous = queue_command(get_node(cast), "finished")
	# NOTE: only yield conditionally, to keep the first command synchronous
	if previous: yield(previous, "completed")
	
	_change_state(get_node(cast), {
		"spell": spell, 
		"targetPos": targetPos
	})
