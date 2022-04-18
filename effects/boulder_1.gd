extends Area

var speed = 50


func _physics_process(delta):
	global_transform.origin += -global_transform.basis.z.normalized() * speed * delta
