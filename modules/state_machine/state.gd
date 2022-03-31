extends Node

# Base interface for all states: it doesn't do anything by itself,
# but forces us to pass the right arguments to the methods below
# and makes sure every State object has all of these methods.

# Whether or not it will be placed on the state stack to be "reversed" (return to previous)
var is_reversible: = false
export var animation_player: NodePath

# NOTE: The parent node (StateMachine) is responsible for this property.
#       Its value will either be the Input singleton, or an AI input node.
var Input

# warning-ignore:unused_signal
signal finished(next_state, args)


# Initialize the state. E.g. change the animation.
func enter(args := {}):
	pass


# Clean up the state. Reinitialize values like a timer.
func exit():
	pass


func handle_input(_event: InputEvent):
	pass


func update(_delta):
	pass


func _on_animation_finished(_anim_name: String):
	pass
