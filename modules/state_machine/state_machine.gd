extends Node
class_name StateMachine

signal state_changed(current_state)

export var start_state: NodePath

var states_stack := []
var current_state: Node = null
var _active := false setget set_active

# NOTE: After _ready(), this will either point to the Input singleton, 
#       or an AI input node.
var Input
export var _ai_input: NodePath setget _set_ai_input

func _set_ai_input(value):
	# NOTE: Must defer until this Node is in the scene tree
	# https://github.com/godotengine/godot/issues/30460#issuecomment-569478670
	if not is_inside_tree(): yield(self, "ready")
	
	set_process_input(!value)
	set_process_unhandled_input(!value)
	
	Input = get_node(value) if value else preload("input_util.gd").get_input()
	var children = get_children()
	for child in children:
		child.Input = Input

func _ready():
	# NOTE: Trigger the setter manually in case the Inspector didn't
	_set_ai_input(_ai_input)
	
	assert(get_children().size(), "Error: StateMachine ('" + get_path() + "') with no States.")
	
	if not start_state:
		start_state = get_child(0).get_path()
	for child in get_children():
		var err = child.connect("finished", self, "_change_state")
		if err:
			printerr(err)
	initialize(start_state)


func initialize(initial_state_path: NodePath):
	set_active(true)
	states_stack.push_front(get_node(initial_state_path))
	current_state = states_stack[0]
	current_state.enter({})


func set_active(value: bool):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)
	

func _physics_process(delta):
	current_state.update(delta)


func _on_animation_finished(anim_name: String):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state: Node = null, args := {}):
	assert(state || current_state.is_reversible, "Error: new state is null, but current_state is not reversible.")
	
	if not _active:
		return
	
	# Push reversible States onto the stack to be removed later.
	if state and state.is_reversible:
		states_stack.push_front(state)
	
	current_state.exit()
	
	# NOTE: null is reserved for "reversing" (returning to previous state).
	if state == null:
		assert(states_stack.size() > 1, "Error: Attempted to return to previous from State ('" + current_state.get_path() + "') with no more States on the stack. Is is_reversible set to true?")
		states_stack.pop_front()
	else:
		states_stack[0] = state
		assert(states_stack[0], "Error: State ('" + state.get_path() + "') not found in '" + get_path() + "'. Is it plugged in?")
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state.get_path())

	# NOTE: This may be useful to allow resuming a State that was interrupted.
#	if state != null:
	current_state.enter(args)
	current_state.emit_signal("entered")
