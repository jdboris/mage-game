extends Control

var mob : KinematicBody

func render() -> void:
	for button in $SkillIcons.get_children():
		button.queue_free()
	
	if mob and mob.has_node("StateMachine/Casting"):
		var spells = mob.get_node("StateMachine/Casting").get_children()
		var index = 1
		
		for spell in spells:
			var button := preload("res://ui/skill_button.tscn").instance()
			button.texture_normal = spell.icon.duplicate()
			$SkillIcons.add_child(button)
			
			button.get_node("KeyLabel").text = str(index)
			index += 1
			
			if spell.cooldown_timer.time_left > 0:
				button.material.blend_mode = BLEND_MODE_MUL
				button.get_node("CooldownLabel").text = str(ceil(spell.cooldown_timer.time_left))
