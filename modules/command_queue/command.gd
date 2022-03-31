extends Node

var previous: GDScriptFunctionState
var _root: GDScriptFunctionState

func _init(new_previous: GDScriptFunctionState, root: GDScriptFunctionState) -> void:
	self.previous = new_previous
	_root = root

func end():
	_root.resume()
