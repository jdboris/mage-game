extends Node

export var animation_player: NodePath
export var cast_animation: NodePath = "Spell1"
export var fireball: PackedScene
export var damage: float = 10
export var castTime: float = 0.4

func cast(args = {"target": Vector3.ZERO}):
	(get_node(animation_player) as AnimationPlayer).play(cast_animation, -1, 1 / castTime)
	
	var explosion = (fireball.instance() as Area)
	explosion.connect("body_entered", self, "_on_Explosion_1_body_entered")
	explosion.translation = args.target
	Global.level.add_child(explosion)

func _on_Explosion_1_body_entered(body: KinematicBody) -> void:
	if body:
		body.get_node("Health").value -= damage
