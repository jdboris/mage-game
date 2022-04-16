extends "res://modules/state_machine/state.gd"

func update_look_direction(direction: Vector3):
	if direction:
		owner.look_at(owner.global_transform.origin + direction, Vector3.UP)
