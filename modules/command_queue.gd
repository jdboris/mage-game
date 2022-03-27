extends Node

var _promises := []

#class Command:
#	var previous: GDScriptFunctionState
#	var _current: GDScriptFunctionState
#
#	func _init(previous: GDScriptFunctionState, current: GDScriptFunctionState) -> void:
#		self.previous = previous
#		_current = current
#
#	func end():
#		_current.resume()
#var command = Command.new(previous, root)

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
