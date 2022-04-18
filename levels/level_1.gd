extends Node

var Mage := preload("res://mobs/mage.tscn")

var SkeletonWarriorGroup := preload("res://mob_groups/skeleton_warrior_group.tscn")
var SkeletonWarriorLine := preload("res://mob_groups/skeleton_warrior_line.tscn")


func _ready() -> void:
	randomize()

	var mage := Mage.instance()
	add_child(mage)
	spawn_infinitely(mage)


func spawn_infinitely(mage):
	var formations = [SkeletonWarriorGroup, SkeletonWarriorLine]

	var count := 20.0
	var interval := 1.0

	while count > 0:
		interval = interval if interval <= 1 else interval - 1
		count -= 1
		print("SPAWNING WAVE ", count)

		var angle := rand_range(0, 359)
		var distance := 30

		var direction := Vector3.FORWARD.rotated(Vector3.UP, deg2rad(angle))
		var spawn_point := direction * distance

		var formation = instance_formation(formations[randi() % formations.size()])
		add_child(formation)
		formation.global_translate(spawn_point)
		formation.look_at(Vector3(0, 0, 0), Vector3.UP)

		# Initial aggro
		for mob in formation.get_children():
			mob.get_node("MeleeAiInput").target = mage.get_node("MobHurtbox")

		yield(get_tree().create_timer(interval), "timeout")

func instance_formation(formation):
	return formation.instance()
