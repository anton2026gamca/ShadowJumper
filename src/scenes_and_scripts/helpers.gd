extends Node
class_name Helpers


static func find_child_by_type(parent: Node, type: Variant) -> Node:
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null
