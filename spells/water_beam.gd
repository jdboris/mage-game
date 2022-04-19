extends Node

export var animation_player: NodePath
export var cast_animation: String
export var damage: float = 50
export var cast_time: float = 0.4
export var cooldown: float = 5
var cooldown_timer := Timer.new()

export var water_beam1: PackedScene

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
	
	
	var caster: KinematicBody = owner
	var water_beam: Area = water_beam1.instance()
	water_beam.connect("area_entered", self, "_on_WaterBeam1_area_entered")
	Global.level.add_child(water_beam)
	water_beam.global_transform.origin = caster.global_transform.origin
	water_beam.look_at(args.target, Vector3.UP)

	CollisionLayers.set_opposite_bits(
		water_beam,
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
