extends State
class_name BeeNotInRange


@export var target: Bee

@export var attack_start_area: Area2D
@export var sprite: AnimatedSprite2D
@export var buzzing_audio: AudioStreamPlayer2D


func process(delta: float) -> Variant:
	if not target.enemy: return null
	if target.can_use_ultimate_attack and target.ultimate_attack_area.get_overlapping_bodies().has(target.enemy):
		return BeeUltimateAttack
	if attack_start_area.get_overlapping_bodies().has(target.enemy):
		target.velocity = Vector2.ZERO
		return BeeAttacking
	target.velocity = (target.enemy.global_position - attack_start_area.global_position).normalized() * target.fly_speed
	sprite.flip_h = target.velocity.x > 0
	return null


func on_enter() -> void:
	if buzzing_audio:
		buzzing_audio.finished.connect(_on_buzzing_audio_finished)
		if not buzzing_audio.playing:
			buzzing_audio.play()

func on_exit() -> void:
	if buzzing_audio:
		buzzing_audio.finished.disconnect(_on_buzzing_audio_finished)

func _on_buzzing_audio_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	buzzing_audio.play()
