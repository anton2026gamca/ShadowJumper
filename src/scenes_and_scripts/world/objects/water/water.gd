extends Node2D
class_name Water


@export var lightning_interval: float = 2

@onready var lightning_sprite: AnimatedSprite2D = $LightningSprite
@onready var lightning_sound_effect: AudioStreamPlayer2D = $LightningSoundEffect
@onready var point_light: PointLight2D = $PointLight2D



func _ready() -> void:
	get_tree().create_timer(randf_range(0, lightning_interval), false).timeout.connect(_emit_lightning)
	lightning_sprite.animation_finished.connect(func() -> void: point_light.visible = false)

func _process(delta: float) -> void:
	pass


func _emit_lightning() -> void:
	lightning_sprite.speed_scale = randf_range(1.0, 2.0)
	lightning_sprite.play("default")
	point_light.visible = true
	if not Engine.is_editor_hint():
		lightning_sound_effect.pitch_scale = randf_range(0.75, 1.25)
		lightning_sound_effect.play()
	get_tree().create_timer(lightning_interval, false).timeout.connect(_emit_lightning)
