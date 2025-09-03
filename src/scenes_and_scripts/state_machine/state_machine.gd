@tool
extends Node
class_name StateMachine


var enable_in_editor: bool = false

@export var current_state: State


func _ready() -> void:
	enable_in_editor = false
	if Engine.is_editor_hint():
		return
	if not current_state:
		current_state = get_children().filter(func(node: Node) -> bool: return node is State)[0]
	current_state.on_enter()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	var new_state_name: String = current_state.process(delta)
	var new_state: State = get_node_or_null(new_state_name)
	if new_state:
		current_state.on_exit()
		new_state.on_enter()
		current_state = new_state
