extends Node

onready var cameraPivot: Spatial = $"../Main/CameraPivot"
onready var camera: Camera = $"../Main/CameraPivot/Camera"

onready var level: = $"../Main"

func get_position_at_point_from_camera(point: Vector2, relCamera: Camera = camera) -> Vector3:
	var space_state = relCamera.get_world().direct_space_state
	var rayOrigin = relCamera.project_ray_origin(point)
	var rayEnd = rayOrigin + relCamera.project_ray_normal(point) * 2000
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd, [], level.get_node("Ground").collision_layer)
	
	if not intersection.empty():
		return intersection.position
	else:
		return Vector3.ZERO
	
