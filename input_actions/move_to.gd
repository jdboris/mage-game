extends InputEventAction
class_name MoveToAction

var position: Vector2

func _init(position) -> void:
	self.action = "move_to"
	self.pressed = true
	self.strength = 1
	self.position = position
