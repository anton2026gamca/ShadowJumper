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
	var new_type: Variant = current_state.process(delta)
	var children: Array[Node] = get_children()
	if not new_type:
		return
	var new_state: Variant = Helpers.find_child_by_type(self, new_type)
	if not new_state is State:
		return
	current_state.on_exit()
	new_state.on_enter()
	current_state = new_state
