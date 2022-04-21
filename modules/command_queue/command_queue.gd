# Description: 
# A queue for "commands", to facilitate following the "command pattern".

# How to use:

# var commands: = CommandQueue.new()
# ...
# var command: = commands.new_command()
# # NOTE: only yield conditionally, to keep the first command synchronous
# if command.previous: yield(command.previous, "completed")
# ...
# # NOTE: If necessary, yield again to await the full command duration...
# yield(get_node(cast), "finished")
# command.end()

extends Node
const Command: = preload("command.gd")

var queue := []

func new_command() -> Command:
	var previous = queue.back() if not queue.empty() else null
	var root = _empty_promise()
	_promise_command()
	_push_promise(root)
	
	return Command.new(previous, root)

func _promise_command():
	if queue.size():
		yield(queue.back(), "completed")

func _push_promise(promise: GDScriptFunctionState):
	queue.push_back(promise)
	var error: = promise.connect("completed", self, "_pop_promise")
	assert(!error, "Error: Failed to connect to '_pop_promise' signal.")

func _pop_promise():
	return queue.pop_front()

func _empty_promise():
	yield()
