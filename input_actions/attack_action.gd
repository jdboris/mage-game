extends InputEventAction
class_name AttackAction

var target

func _init(target) -> void:
	self.action = "attack"
	self.pressed = true
	self.strength = 1
	self.target = target
