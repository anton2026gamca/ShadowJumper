extends Node
class_name StateMachine


@export var current_state: State


func _ready() -> void:
	if not current_state:
		current_state = get_children().filter(func(node: Node) -> bool: return node is State)[0]
	current_state.on_enter()

func _process(delta: float) -> void:
	var new_state_name: String = current_state.process(delta)
	var new_state: State = get_node_or_null(new_state_name)
	if new_state:
		current_state.on_exit()
		new_state.on_enter()
		current_state = new_state
