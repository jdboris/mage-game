extends "res://modules/ai_input/ai_input.gd"

func _ready() -> void:
	target = (get_node("../../Mage") as KinematicBody) 

func _process(_delta: float):
	
	if target:
		var mob = (owner as KinematicBody)
		move_mob_towards_target(mob, target)
