# How to use:
# Autoload/Singleton

extends Node

enum Layers {}

# Set the given bits in the target opposite to those bits in the source.
func set_opposite_bits(target: CollisionObject, source: CollisionObject, bits: = []):
	for bit in bits:
		target.set_collision_mask_bit(bit, !source.get_collision_layer_bit(bit))

func _ready() -> void:
	_read_from_settings()

func _read_from_settings():
	var names_in_settings = {}
	for i in range(1, 21):
		var name = ProjectSettings.get_setting("layer_names/3d_physics/layer_" + str(i))
		if name:
			names_in_settings[name] = i-1
	
	for name in names_in_settings:
#		if not name in names_in_settings:
#			return false
		Layers[name] = names_in_settings[name]

func get_layer(name) -> int:
	_read_from_settings()
	return Layers[name]
