extends AnimatedSprite2D
class_name PowerupObject


@export var powerup: PackedScene
@export var pickup_audio: AudioStream

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var area_2d: Area2D = $Area2D


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	if not body.pickup_powerup(powerup):
		return
	area_2d.set_deferred("monitoring", false)
	audio_stream_player_2d.stream = pickup_audio
	audio_stream_player_2d.play()
	play("pickup")
	Helpers.create_floating_text(get_parent(), "+1 HP", global_position + Vector2(0, -16), Color.LIGHT_BLUE)
	await animation_finished
	visible = false
	while audio_stream_player_2d.playing:
		await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
