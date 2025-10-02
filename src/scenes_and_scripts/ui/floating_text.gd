extends Label
class_name FloatingText


@export var duration: float = 4
@export var y_diff: float = -10
@export var color: Color = Color.WHITE


func start() -> void:
	add_theme_color_override("font_color", color)
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", position + y_diff * Vector2.DOWN, duration - 1)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	destroy()

func destroy() -> void:
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
