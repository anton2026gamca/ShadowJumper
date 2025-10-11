extends Sprite2D
class_name PickupableRock


@export var amount: float = 1
@export var text_color: Color = Color.PURPLE

@onready var area_2d: Area2D = $Area2D
@onready var pickup_audio: AudioStreamPlayer2D = $PickupAudio


func _on_body_entered(body: Node2D) -> void:
	if body is Player and visible:
		visible = false
		var text: FloatingText = Helpers.create_floating_text(get_parent(), ("+" if amount >= 0 else "") + str(int(amount)) + " R", position + Vector2(0, -24), text_color, -10)
		text.process_mode = Node.PROCESS_MODE_ALWAYS
		Settings.collect_rocks(amount)
		pickup_audio.play()
		await pickup_audio.finished
		get_parent().remove_child(self)
		queue_free()
