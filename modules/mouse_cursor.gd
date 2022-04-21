# How to use:
# Autoload/Singleton

extends Node

var cursor = null

func set_mouse_cursor(cursor: PackedScene):
	if self.cursor:
		remove_child(self.cursor)
		self.cursor = null
	
	if cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		self.cursor = cursor.instance()
		add_child(self.cursor)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
