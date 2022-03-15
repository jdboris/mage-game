extends Node

export var mobPath: NodePath

func _physics_process(delta: float) -> void:
	if !mobPath: return
	var mob = get_node(mobPath)
	
	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	mob.velocity.x = direction.x * mob.speed
	mob.velocity.z = direction.z * mob.speed
	
	# Move, then update the velocity in case there were collisions
	mob.velocity = mob.move_and_slide(mob.velocity, Vector3.UP)
