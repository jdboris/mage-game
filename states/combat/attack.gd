extends "res://modules/state.gd"


func enter(args := {}):
	get_node(animation_player).play("Idle -loop")


func _on_Sword_attack_finished():
	emit_signal("finished", null, {})
