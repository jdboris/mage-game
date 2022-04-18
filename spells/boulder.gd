extends Node

signal cast_canceled

export var animation_player: NodePath
export var cast_animation: String
export var boulder1: PackedScene
export var damage: float = 50
export var cast_time: float = 0.4
export var cooldown: float = 5
var cooldown_timer := Timer.new()

func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func cast(args = {"target": Vector3.ZERO}):
	print("cooldown_timer.time_left: ", cooldown_timer.time_left)
	if cooldown_timer.time_left > 0:
		emit_signal("cast_canceled")
		return
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
	hurtbox.mob_health.value -= damage
	hurtbox.ai_input.set_target(owner)
	boulder.queue_free()
