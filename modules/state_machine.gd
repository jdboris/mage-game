extends Node

signal state_changed(current_state)

export var start_state: NodePath

var states_stack := []
var current_state = null
var _active := false setget set_active

export var _ai_input: NodePath setget _set_ai_input

func _set_ai_input(value):
	# NOTE: Must defer until this Node is in the scene tree
	# https://github.com/godotengine/godot/issues/30460#issuecomment-569478670
	if not is_inside_tree(): yield(self, "ready")
	
	set_process_input(!value)
	set_process_unhandled_input(!value)
	
#	assert(input != @"", "Error: Input NodePath<CustomInput> ('" + input + "') empty in '" + get_path() + "'. Is it plugged in?")
	
	var input = get_node(value) if value else Input
	var children = get_children()
	for child in children:
		child.Input = input

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


func _change_state(state: Node, args := {}):
	if not _active:
		return
	current_state.exit()

	# NOTE: null is reserved for returning to previous state
	if state == null:
		states_stack.pop_front()
	else:
		states_stack[0] = state
		assert(states_stack[0], "Error: State ('" + state.get_path() + "') not found in '" + get_path() + "'. Is it plugged in?")

	current_state = states_stack[0]
	emit_signal("state_changed", current_state.get_path())

	if state != null:
		current_state.enter(args)
