extends Sprite2D
class_name PickupableRock


@export var amount: float = 1
@export var text_color: Color = Color.PURPLE

@onready var area_2d: Area2D = $Area2D
@onready var pickup_audio: AudioStreamPlayer2D = $PickupAudio
@onready var pickup_particles: CPUParticles2D = $PickupParticles
@onready var point_light_2d: PointLight2D = $PointLight2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player and self_modulate.a > 0:
		self_modulate.a = 0
		point_light_2d.visible = false
		var text: FloatingText = Helpers.create_floating_text(get_parent(), ("+" if amount >= 0 else "") + str(int(amount)) + " R", position + Vector2(0, -24), text_color, -10)
		text.process_mode = Node.PROCESS_MODE_ALWAYS
		Settings.collect_rocks(amount)
		pickup_audio.play()
		pickup_audio.pitch_scale = randf_range(0.7, 1.3)
		pickup_particles.emitting = true
		while pickup_audio.playing or pickup_particles.emitting:
			await get_tree().process_frame
		get_parent().remove_child(self)
		queue_free()
