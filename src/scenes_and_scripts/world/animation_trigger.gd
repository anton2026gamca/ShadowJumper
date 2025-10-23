@tool
extends Node2D
class_name AnimationTrigger


@export var enable: bool = true

@export var animation_tree: AnimationTree
@export var transitions: Array[AnimationTriggerTransition] = []

@export var source: Node2D

var current_transition: int = 0


func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	if not enable:
		current_transition = 0
		return
	for i: int in len(transitions):
		var area: Node = get_node(transitions[i].area)
		if area is CollisionShape2D and area.shape is RectangleShape2D:
			var left: float = area.position.x - area.shape.size.x / 2.0
			var right: float = left + area.shape.size.x
			if source.position.x >= left and source.position.x <= right:
				current_transition = i + 1
			var value: float = clamp((source.position.x - left) / area.shape.size.x, 0.0, 1.0)
			var property: StringName = "parameters/" + transitions[i].blend_space_path + "/blend_position"
			animation_tree.set(property, value)
			#print(transitions[i].blend_space_path, ": ", value, " | ", current_transition)
