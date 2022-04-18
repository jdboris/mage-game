extends Node

export var animation_player: NodePath
export var cast_animation: String
export var fireball: PackedScene
export var damage: float = 10
export var castTime: float = 0.4


func cast(args = {"target": Vector3.ZERO}):
	var player := (get_node(animation_player) as AnimationPlayer)
	player.play(cast_animation)
	player.playback_speed = player.current_animation_length / castTime

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
