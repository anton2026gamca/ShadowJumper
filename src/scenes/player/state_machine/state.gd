extends Node
class_name State


var state_machine: StateMachine
var player: Player


func _ready() -> void:
	if get_parent() is StateMachine:
		state_machine = get_parent()
		player = state_machine.player
	else:
		push_warning("State is not a child of a state machine!")

func process(delta: float) -> State:
	return null
