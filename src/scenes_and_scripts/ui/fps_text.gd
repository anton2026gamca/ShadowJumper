extends RichTextLabel
class_name FpsText


func _ready() -> void:
	if OS.has_feature("template"):
		await get_tree().process_frame
		get_parent().remove_child(self)
		queue_free()

func _process(delta: float) -> void:
	var fps: int = floor(Engine.get_frames_per_second())
	var color: Color = Color.GRAY
	if fps < 10: color = Color.RED
	elif fps < 20: color = Color.ORANGE
	elif fps < 30: color = Color.YELLOW
	text = "[color=#" + color.to_html() + "]" + str(fps) + " FPS[/color]"
