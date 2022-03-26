extends "res://modules/state.gd"
# The stagger state end with the stagger animation from the AnimationPlayer.
# The animation only affects the Body Sprite's modulate property so it
# could stack with other animations if we had two AnimationPlayer nodes.




func enter(args := {}):
	get_node(animation_player).play("stagger")


func _on_animation_finished(anim_name: String):
	assert(anim_name == "stagger")
	emit_signal("finished", null, {})
