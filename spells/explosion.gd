extends Node

export var icon: Texture
export var cast_sound: AudioStream
var _audio_player := AudioStreamPlayer.new()
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export var cast_animation: String
export var damage: float = 10
export var cast_time: float = 0.4
export var cooldown: float = 5
var cooldown_timer := Timer.new()

export var fireball: PackedScene


func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	add_child(_audio_player)
	_audio_player.stream = cast_sound.duplicate()


func cast(args = {"target": Vector3.ZERO}):
	if cooldown_timer.time_left > 0:
		print("cooldown_timer.time_left: ", cooldown_timer.time_left)
		return false

	_audio_player.play()
	cooldown_timer.start(cooldown)

	animation_player.play(cast_animation)
	animation_player.playback_speed = animation_player.current_animation_length / cast_time

	var explosion = fireball.instance() as Area
	explosion.connect("area_entered", self, "_on_Explosion1_area_entered")
	Global.level.add_child(explosion)
	explosion.global_transform.origin = args.target

	var caster = owner as KinematicBody

	CollisionLayers.set_opposite_bits(
		explosion,
		caster,
		[
			CollisionLayers.Layers.FRIENDLY,
			CollisionLayers.Layers.NEUTRAL,
			CollisionLayers.Layers.HOSTILE
		]
	)


func _on_Explosion1_area_entered(hurtbox: MobHurtbox):
	hurtbox.mob_health.value -= damage
	hurtbox.ai_input.set_target(owner)
