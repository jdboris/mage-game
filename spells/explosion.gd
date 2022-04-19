extends Node

export var animation_player: NodePath
export var cast_animation: String
export var damage: float = 10
export var cast_time: float = 0.4
export var cooldown: float = 5
var cooldown_timer := Timer.new()

export var fireball: PackedScene

func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func cast(args = {"target": Vector3.ZERO}):
	if cooldown_timer.time_left > 0:
		print("cooldown_timer.time_left: ", cooldown_timer.time_left)
		return false
	
	cooldown_timer.start(cooldown)
	
	var player := (get_node(animation_player) as AnimationPlayer)
	player.play(cast_animation)
	player.playback_speed = player.current_animation_length / cast_time

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
