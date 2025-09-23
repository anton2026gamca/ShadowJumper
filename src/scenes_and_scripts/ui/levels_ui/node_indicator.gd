extends Control
class_name NodeIndicator


@onready var color_rect: ColorRect = $ColorRect

var origin_point: Camera2D
var target: Node2D

var color: Color:
	set(value): color_rect.color = value
	get: return color_rect.color

signal destroyed


func _process(delta: float) -> void:
	if not visible or not target or not origin_point:
		return
	var viewport_size: Vector2 = size - color_rect.size
	var screen_center: Vector2 = origin_point.get_screen_center_position()
	var world_to_screen_offset: Vector2 = viewport_size * 0.5 - screen_center
	var origin_pos: Vector2 = origin_point.global_position + world_to_screen_offset
	var target_pos: Vector2 = target.global_position + world_to_screen_offset
	var dir: Vector2 = (target_pos - origin_pos).normalized()
	var t: float = INF
	if dir.x != 0.0:
		var tx1: float = -origin_pos.x / dir.x
		var tx2: float = (viewport_size.x - origin_pos.x) / dir.x
		if tx1 > 0: t = min(t, tx1)
		if tx2 > 0: t = min(t, tx2)
	if dir.y != 0.0:
		var ty1: float = -origin_pos.y / dir.y
		var ty2: float = (viewport_size.y - origin_pos.y) / dir.y
		if ty1 > 0: t = min(t, ty1)
		if ty2 > 0: t = min(t, ty2)
	var border_pos: Vector2 = origin_pos + dir * t
	border_pos = border_pos.clamp(Vector2.ZERO, viewport_size)
	color_rect.position = border_pos


func destroy() -> void:
	destroyed.emit()
	get_parent().remove_child.call_deferred(self)
	queue_free()
