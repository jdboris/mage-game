extends Node

export var icon: Texture
export var cast_sound: AudioStream
var _cast_sound_player := AudioStreamPlayer.new()
export var animation_player: NodePath
export var cast_animation: String
export var damage: float = 50
export var cast_time: float = 0.4
export var cooldown: float = 5
var cooldown_timer := Timer.new()

export var boulder1: PackedScene
export var impact_sound: AudioStream
var _impact_sound_player := AudioStreamPlayer.new()

func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	
	add_child(_cast_sound_player)
	_cast_sound_player.stream = cast_sound.duplicate()
	_cast_sound_player.pitch_scale = 2.5
	
	add_child(_impact_sound_player)
	_impact_sound_player.stream = impact_sound.duplicate()
	_impact_sound_player.pitch_scale = 2

func cast(args = {"target": Vector3.ZERO}):
	if cooldown_timer.time_left > 0:
		print("cooldown_timer.time_left: ", cooldown_timer.time_left)
		return false
	
	_cast_sound_player.play()
	cooldown_timer.start(cooldown)
	
	var player := (get_node(animation_player) as AnimationPlayer)
	player.play(cast_animation)
	player.playback_speed = player.current_animation_length / cast_time
	
	var caster: KinematicBody = owner
	var boulder: Area = boulder1.instance()
	boulder.connect("area_entered", self, "_on_Boulder1_area_entered", [boulder])
	Global.level.add_child(boulder)
	boulder.global_transform.origin = caster.global_transform.origin
	boulder.look_at(args.target, Vector3.UP)

	CollisionLayers.set_opposite_bits(
		boulder,
		caster,
		[
			CollisionLayers.Layers.FRIENDLY,
			CollisionLayers.Layers.NEUTRAL,
			CollisionLayers.Layers.HOSTILE
		]
	)


func _on_Boulder1_area_entered(hurtbox: MobHurtbox, boulder):
	_impact_sound_player.play()
	hurtbox.mob_health.value -= damage
	hurtbox.ai_input.set_target(owner)
	boulder.queue_free()
