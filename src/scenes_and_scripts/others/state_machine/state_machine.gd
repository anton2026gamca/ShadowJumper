@tool
extends Node
class_name StateMachine


var enabled: bool = true

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
	if Engine.is_editor_hint() and not enable_in_editor or not enabled:
		return
	var new_type: Variant = current_state.process(delta)
	if not new_type:
		return
	var new_state: Variant = find_child_by_type(self, new_type)
	if not new_state is State:
		return
	current_state.on_exit()
	new_state.on_enter()
	current_state = new_state

func find_child_by_type(parent: Node, type: Variant) -> Node:
	if not parent:
		return null
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null
