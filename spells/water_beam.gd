extends Node

export var animation_player: NodePath
export var cast_animation: String
export var water_beam: PackedScene
export var damage: float = 50
export var castTime: float = 0.4


func cast(args = {"target": Vector3.ZERO}):
	(get_node(animation_player) as AnimationPlayer).play(cast_animation, -1, 1 / castTime)

	var caster: KinematicBody = owner
	var explosion: Area = water_beam.instance()
	explosion.connect("area_entered", self, "_on_WaterBeam1_area_entered")
	Global.level.add_child(explosion)
	explosion.global_transform.origin = caster.global_transform.origin
	explosion.look_at(args.target, Vector3.UP)

	CollisionLayers.set_opposite_bits(
		explosion,
		caster,
		[
			CollisionLayers.Layers.FRIENDLY,
			CollisionLayers.Layers.NEUTRAL,
			CollisionLayers.Layers.HOSTILE
		]
	)


func _on_WaterBeam1_area_entered(hurtbox: MobHurtbox):
	hurtbox.mob_health.value -= damage
	hurtbox.ai_input.set_target(owner)
