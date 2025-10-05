extends Node


var main_menu: Main
var levels_ui: LevelsUI
var camera: CameraPlus

const FLOATING_TEXT_SCENE: PackedScene = preload("res://scenes_and_scripts/ui/floating_text.tscn")


func find_child_by_type(parent: Node, type: Variant) -> Node:
	if not parent:
		return null
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null

func get_nearest_node_in_group(from_pos: Vector2, group: String) -> Node2D:
	var nearest: Node2D = null
	var nearest_distance: float = INF
	for node: Node in get_tree().get_nodes_in_group(group):
		if not node is Node2D:
			return
		var dist: float = from_pos.distance_squared_to(node.global_position)
		if dist < nearest_distance:
			nearest_distance = dist
			nearest = node
	return nearest

func create_floating_text(parent: Node, text: String, position: Vector2, color = Color.RED, y_diff: float = 0, duration: float = 4) -> FloatingText:
	var node: FloatingText = FLOATING_TEXT_SCENE.instantiate()
	node.text = text
	node.position = position - node.size / 2
	node.color = color
	node.y_diff = y_diff
	node.duration = duration
	parent.add_child(node)
	node.start()
	return node
