extends "res://modules/ai_input/ai_input.gd"

var target: KinematicBody

func _ready() -> void:
	target = (get_node("../../Mage") as KinematicBody) 

func set_target(mob: KinematicBody):
	target = target if target else mob

func _process(_delta: float):
	if target:
		emit_signal("input",
			MoveToAction.new(Global.get_2d_position_at_point(target.global_transform.origin))
		)
