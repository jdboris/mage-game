extends "res://modules/state_machine/state.gd"

export var death_animation: String
export var dead_animation: String

export var death_sound: AudioStream
var _death_sound_player := AudioStreamPlayer.new()

func enter(args := {}):
	
	if death_animation:
		get_node(animation_player).play(death_animation)
		
		add_child(_death_sound_player)
		_death_sound_player.stream = death_sound.duplicate()
		_death_sound_player.pitch_scale = rand_range(1, 1.3)
		_death_sound_player.volume_db = rand_range(-6, -3)
		_death_sound_player.play(rand_range(0, 0.05))
		
	elif dead_animation:
		get_node(animation_player).play(dead_animation)

func _on_animation_finished(_anim_name):
	if _anim_name == death_animation:
		get_node(animation_player).play(dead_animation)
