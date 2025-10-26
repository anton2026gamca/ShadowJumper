extends AnimatedSprite2D
class_name PowerupObject


@export var powerup: PackedScene
@export var pickup_audio_override: AudioStream

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var area_2d: Area2D = $Area2D

signal picked_up


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	var powerup_node: Powerup = body.pickup_powerup(powerup)
	if not powerup_node:
		return
	area_2d.set_deferred("monitoring", false)
	if pickup_audio_override: audio_stream_player_2d.stream = pickup_audio_override
	audio_stream_player_2d.play()
	play("pickup")
	Helpers.create_floating_text(get_parent(), powerup_node.pickup_message, global_position + Vector2(0, -32), Color.LIGHT_BLUE, -16)
	picked_up.emit()
	await animation_finished
	visible = false
	while audio_stream_player_2d.playing:
		await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
