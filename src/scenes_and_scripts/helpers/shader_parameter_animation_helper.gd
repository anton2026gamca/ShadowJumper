@tool
extends Node
class_name ShaderParameterAnimationHelper


@export var node_with_material: CanvasItem
@export var param: StringName

var value_before: Variant


func _process(delta: float) -> void:
	if "value" in self:
		if typeof(value_before) == typeof(get("value")) and value_before != get("value"):
			update_shader_parameter(get("value"))
		value_before = get("value")


func update_shader_parameter(value: Variant) -> void:
	if not node_with_material or not node_with_material.material:
		return
	node_with_material.material.set_shader_parameter(param, value)
