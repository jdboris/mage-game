extends Node

export var animation_player: NodePath
export var cast_animation: String
export var boulder1: PackedScene
export var damage: float = 50
export var castTime: float = 0.4


func cast(args = {"target": Vector3.ZERO}):
	var player := (get_node(animation_player) as AnimationPlayer)
	player.play(cast_animation)
	player.playback_speed = player.current_animation_length / castTime
	
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
	hurtbox.mob_health.value -= damage
	hurtbox.ai_input.set_target(owner)
	boulder.queue_free()
