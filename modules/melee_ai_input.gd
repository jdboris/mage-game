extends "res://modules/ai_input/ai_input.gd"

func _process(_delta: float):
	var mob = (owner as KinematicBody)
	var mage = (get_node("../../Mage") as KinematicBody)
	
	var distance = mob.global_transform.origin.distance_to(mage.global_transform.origin)
	target = mage if not target and distance < 8 else target
	
	move_mob_towards_target(mob, target)
