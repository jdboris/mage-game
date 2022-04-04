extends Node
class_name FloatProp

signal value_changed(old_value, prop)

# NOTE: The order of these matters
export var min_value: float = 0
export var max_value: float = 999
export var value: float setget set_value

func set_value(new_value: float):
	var old_value: = value
	if new_value < min_value: new_value = min_value
	if new_value > max_value: new_value = max_value
	value = new_value
	
	emit_signal("value_changed", old_value, self)
