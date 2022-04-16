extends Node

var Mage = preload("res://mobs/mage.tscn")
var SkeletonWarriorGroup = preload("res://mob_groups/skeleton_warrior_group.tscn")

func _ready() -> void:
	var mage = Mage.instance()
	add_child(mage)
	
	var spawn_point = Vector3(10, 0, 0)
	var group = SkeletonWarriorGroup.instance()
	add_child(group)
	group.global_translate(spawn_point)
	group.look_at(mage.global_transform.origin, Vector3.UP)
	
	# Initial aggro
	for mob in group.get_children():
		mob.get_node("MeleeAiInput").target = mage.get_node("MobHurtbox")


