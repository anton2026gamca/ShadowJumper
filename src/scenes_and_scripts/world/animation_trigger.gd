@tool
extends Node2D
class_name AnimationTrigger


@export var enabled: bool = true

@export var animation_tree: AnimationTree
@export var transitions: Array[AnimationTriggerTransition] = []

var last_pos: Vector2 = Vector2.ZERO
@export var source: Node2D

var current_transition: int = 0


func _ready() -> void:
	animation_tree.active = true
	update()
	last_pos = source.position

func _process(delta: float) -> void:
	if source.position != last_pos:
		update()
		last_pos = source.position

func update() -> void:
	current_transition = 0
	if not enabled:
		return
	for i: int in len(transitions):
		var area: Node = get_node(transitions[i].area)
		if area is CollisionShape2D and area.shape is RectangleShape2D:
			var left: float = area.position.x - area.shape.size.x / 2.0
			var right: float = left + area.shape.size.x
			if source.position.x <= right:
				current_transition = i + 1
				var value: float = clamp((source.position.x - left) / area.shape.size.x * 2.0 - 1.0, -1.0, 1.0)
				print(value, "A")
				var property: StringName = "parameters/" + transitions[i].blend_space_path + "/blend_position"
				animation_tree.set(property, value)
				break
	if current_transition == 0 and len(transitions) > 0:
		var i: int = len(transitions) - 1
		var area: Node = get_node(transitions[i].area)
		if area is CollisionShape2D and area.shape is RectangleShape2D:
			current_transition = i + 1
			var left: float = area.position.x - area.shape.size.x / 2.0
			var right: float = left + area.shape.size.x
			var property: StringName = "parameters/" + transitions[i].blend_space_path + "/blend_position"
			var value: float = clamp((source.position.x - left) / area.shape.size.x * 2.0 - 1.0, -1.0, 1.0)
			animation_tree.set(property, value)
