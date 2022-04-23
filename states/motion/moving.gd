extends "on_ground.gd"

export var walk_animation: String

export(NodePath) onready var idle = get_node(idle) as Node

export var max_walk_speed := 4
export var max_run_speed := 8
var target_pos: Vector3
var stop_threshold := 0.5


func enter(args := {"target_pos": Vector3.ZERO}):
	speed = 0.0
	velocity = Vector3()
	target_pos = args.target_pos if "target_pos" in args else target_pos

	var direction = owner.global_transform.origin.direction_to(target_pos)
	update_look_direction(direction)
	assert(
		animation_player,
		(
			"Error: AnimationPlayer ('"
			+ animation_player.get_path()
			+ "') not found in '"
			+ get_path()
			+ "'. Is it plugged in?"
		)
	)
	animation_player.play(walk_animation)


func handle_input(event: InputEvent):
	return .handle_input(event)


func update(_delta):
	if (owner as KinematicBody).global_transform.origin.distance_to(target_pos) <= stop_threshold:
		emit_signal("finished", idle, {})

	var direction = owner.global_transform.origin.direction_to(target_pos)
	if not direction:
		emit_signal("finished", idle, {})
	update_look_direction(direction)

	speed = max_walk_speed

	var collision_info = move(speed, direction)
	if not collision_info:
		return
	if speed == max_run_speed and collision_info.collider.is_in_group("environment"):
		return null


func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector3(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
