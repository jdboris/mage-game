extends Node
class_name PropertyNode

signal value_changed(old_value, new_value)

# NOTE: The order of these matters
export var min_value: float
export var max_value: float
export var value: float setget set_value

func set_value(new_value):
	var old_value = value
	if new_value < min_value: new_value = min_value
	if new_value > max_value: new_value = max_value
	value = new_value
	
	emit_signal("value_changed", old_value, new_value)
