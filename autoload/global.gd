extends Node

onready var cameraPivot: Spatial = $"../Level/CameraPivot"
onready var camera: Camera = $"../Level/CameraPivot/Camera"

onready var level: = $"../Level"

onready var fps_timer: = Timer.new()

func _ready() -> void:
	fps_timer.connect("timeout", self, "update_fps")
	fps_timer.wait_time = 1
	add_child(fps_timer)
	fps_timer.start()

func update_fps():
	OS.set_window_title("FPS: " + str(Engine.get_frames_per_second()))

func get_3d_position_at_point(point: Vector2, rel_camera: Camera = camera) -> Vector3:
	var space_state = rel_camera.get_world().direct_space_state
	var ray_origin = rel_camera.project_ray_origin(point)
	var ray_end = ray_origin + rel_camera.project_ray_normal(point) * 2000
	var intersection = space_state.intersect_ray(ray_origin, ray_end, [], level.get_node("Ground").collision_layer)
	
	if not intersection.empty():
		return intersection.position
	else:
		return Vector3.ZERO

func get_2d_position_at_point(point: Vector3, rel_camera: Camera = camera) -> Vector2:
	return rel_camera.unproject_position(point)

# Copy the source to the target and return the target. Facilitates declarative code.
func init_object(target: Object, source: Dictionary):
	for key in source:
		target[key] = source[key]
	return target

func pause_node(node, freeze):
	node.set_process(!freeze)
	node.set_process_internal(!freeze)
	node.set_physics_process(!freeze)
	node.set_physics_process_internal(!freeze)
	node.set_process_input(!freeze)
	node.set_process_unhandled_input(!freeze)
	node.set_process_unhandled_key_input(!freeze)

func pause_scene(node, freeze):
	pause_node(node, freeze)
	for c in node.get_children():
		pause_scene(c, freeze)
