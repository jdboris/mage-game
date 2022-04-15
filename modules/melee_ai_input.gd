extends "res://modules/ai_input/ai_input.gd"

var target: MobHurtbox

func _ready() -> void:
	target = (get_node("../../Mage/MobHurtbox") as MobHurtbox) 

func set_target(value: MobHurtbox):
	target = target if target else value

func _process(_delta: float):
	if target:
		var mob = (owner as KinematicBody)
		var distance = mob.global_transform.origin.distance_to(target.global_transform.origin)
		
		if distance < 2:
			emit_signal("input",
				AttackAction.new(target)
			)
		else:
			emit_signal("input",
				MoveToAction.new(Global.get_2d_position_at_point(target.global_transform.origin))
			)
