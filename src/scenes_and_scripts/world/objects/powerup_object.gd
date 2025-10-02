extends Sprite2D
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
	visible = false
	area_2d.set_deferred("monitoring", false)
	audio_stream_player_2d.stream = pickup_audio
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
