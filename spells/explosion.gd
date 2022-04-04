extends Node

export var animation_player: NodePath
export var cast_animation: String
export var fireball: PackedScene
export var damage: float = 10
export var castTime: float = 0.4

func cast(args = {"target": Vector3.ZERO}):
	(get_node(animation_player) as AnimationPlayer).play(cast_animation, -1, 1 / castTime)
	
	var explosion = (fireball.instance() as Area)
	explosion.connect("area_entered", self, "_on_Explosion_1_area_entered")
	explosion.translation = args.target
	Global.level.add_child(explosion)
	
	var caster = (owner as KinematicBody)
	
	CollisionLayers.set_opposite_bits(explosion, caster, [
		CollisionLayers.Layers.FRIENDLY,
		CollisionLayers.Layers.NEUTRAL,
		CollisionLayers.Layers.HOSTILE
	])

func _on_Explosion_1_area_entered(hurtbox: MobHurtbox):
	hurtbox.mob_health.value -= damage
