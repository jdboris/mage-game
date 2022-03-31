extends "on_ground.gd"

export var walk_animation: String

export var idle: NodePath

export var max_walk_speed: = 4
export var max_run_speed: = 8


func enter(args := {}):
	speed = 0.0
	velocity = Vector3()

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	assert(get_node(animation_player), "Error: AnimationPlayer ('" + animation_player + "') not found in '" + get_path() + "'. Is it plugged in?")
	get_node(animation_player).play(walk_animation)


func handle_input(event: InputEvent):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", get_node(idle), {})
	update_look_direction(input_direction)
	
	speed = max_walk_speed

	var collision_info = move(speed, input_direction)
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
