extends Parallax2D
class_name WorldParallax


@export_range(0, 1, 0.01) var anchor_x: float = 0.5
@export_range(0, 1, 0.01) var anchor_y: float = 0.5


func _ready() -> void:
	if repeat_size.x == 0:
		scroll_offset.x = (scroll_offset.x - get_viewport_rect().size.x * anchor_x) * scroll_scale.x + get_viewport_rect().size.x * anchor_x
	if repeat_size.y == 0:
		scroll_offset.y = (scroll_offset.y - get_viewport_rect().size.y * anchor_y) * scroll_scale.y + get_viewport_rect().size.y * anchor_y
