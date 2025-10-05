extends Label
class_name FloatingText


@export var duration: float = 4
@export var y_diff: float = -10
@export var color: Color = Color.WHITE

signal finished


func start() -> void:
	add_theme_color_override("font_color", color)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + y_diff * Vector2.DOWN, duration)
	await tween.finished
	finished.emit()
	destroy()

func destroy() -> void:
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
