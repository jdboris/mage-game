extends Node

var previous: GDScriptFunctionState
var _root: GDScriptFunctionState

func _init(previous: GDScriptFunctionState, root: GDScriptFunctionState) -> void:
	self.previous = previous
	_root = root

func end():
	_root.resume()
