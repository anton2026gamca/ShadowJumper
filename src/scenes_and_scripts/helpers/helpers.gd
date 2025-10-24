extends Node


var main_menu: Main
var levels_ui: LevelsUI
var camera: CameraPlus
var player: Player

const FLOATING_TEXT_SCENE: PackedScene = preload("res://scenes_and_scripts/ui/floating_text.tscn")
const POWERUP_OBJECT: PackedScene = preload("res://scenes_and_scripts/world/objects/powerup_object.tscn")

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

func create_floating_text(parent: Node, text: String, position: Vector2, color = Color.WHITE, y_diff: float = 0, duration: float = 4) -> FloatingText:
	var node: FloatingText = FLOATING_TEXT_SCENE.instantiate()
	node.text = text
	node.position = position - node.size / 2
	node.color = color
	node.y_diff = y_diff
	node.duration = duration
	parent.add_child(node)
	node.start()
	return node

func get_energy_level_color(val: float) -> Color:
	if val >= 400: return Color.LIME
	elif val >= 200: return Color.YELLOW
	elif val >= 100: return Color.GOLD
	elif val > 0: return Color.ORANGE
	return Color.RED

func spawn_powerup(parent: Node, powerup: PackedScene, position: Vector2) -> void:
	var obj: PowerupObject = POWERUP_OBJECT.instantiate()
	obj.global_position = position
	obj.powerup = powerup
	parent.add_child(obj)

func dictionary_has_path(dict: Dictionary, path: Array) -> bool:
	var current: Variant = dict
	for key: Variant in path:
		if current is Array:
			if not key is int or key < 0 or key >= current.size():
				return false
			current = current.get(key)
		if current is Dictionary:
			current = current.get(key)
		else:
			return false
	return true

func dictionary_get_path(dict: Dictionary, path: Array, default: Variant = null) -> Variant:
	var current: Variant = dict
	for key: Variant in path:
		if current is Array:
			if not key is int or key < 0 or key >= current.size():
				return default
			current = current[key]
		elif current is Dictionary:
			if not current.has(key):
				return default
			current = current[key]
		else:
			return default
	return current

func dictionary_set_path(dict: Dictionary, path: Array, value: Variant, force_string_key: bool = false) -> Variant:
	if path.is_empty():
		return null
	var current: Variant = dict
	for i in range(path.size() - 1):
		var key: Variant = path[i]
		if current is Dictionary:
			if not current.has(key):
				current[key] = {}
			if force_string_key and not key is String:
				return null
			current = current[key]
		elif current is Array:
			if not key is int or key < 0:
				return null
			while key >= current.size():
				current.append({})
			current = current[key]
		else:
			return null
	var last_key = path[path.size() - 1]
	if current is Dictionary:
		current[last_key] = value
	elif current is Array and last_key is int and last_key >= 0 and last_key < current.size():
		current[last_key] = value
	else:
		return null
	return value
