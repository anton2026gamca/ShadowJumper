extends State
class_name BeeAttacking


@export var target: Bee

@export var target_lost_area: Area2D
@export var bullet_scene: PackedScene
@export var bullet_spawner: Node2D
@export var shoot_audio_player: AudioStreamPlayer2D
@export var buzzing_audio: AudioStreamPlayer2D

var current_bullet: BeeBulet

var shoot_enabled: bool = true

var random_dir: Vector2


func process(delta: float) -> Variant:
	if not target.enemy: return null
	if target.can_use_ultimate_attack and target.ultimate_attack_area.get_overlapping_bodies().has(target.enemy):
		return BeeUltimateAttack
	if not target_lost_area.get_overlapping_bodies().has(target.enemy):
		return BeeNotInRange
	target.velocity.x = move_toward(target.velocity.x, Vector2.ZERO.x, 20.0)
	target.velocity.y = move_toward(target.velocity.y, Vector2.ZERO.y, 20.0)
	if not current_bullet and shoot_enabled:
		shoot()
		random_dir = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()
		if not buzzing_audio.playing:
			buzzing_audio.play()
	else:
		random_dir = Vector2(move_toward(random_dir.x, 0, 0.5 * delta), random_dir.y).normalized()
		target.velocity = random_dir * (target.fly_speed / 4)
	return null


func shoot() -> void:
	if not shoot_enabled: return
	current_bullet = bullet_scene.instantiate()
	current_bullet.rotation_degrees = 180
	current_bullet.global_position = bullet_spawner.global_position
	current_bullet.target = target.enemy
	current_bullet.finished.connect(_on_bullet_finished.bind(current_bullet))
	shoot_audio_player.play()
	target.get_parent().add_child(current_bullet)
	shoot_enabled = false
	get_tree().create_timer(target.shoot_cooldown).timeout.connect(func() -> void: shoot_enabled = true)

func _on_bullet_finished(bullet: BeeBulet) -> void:
	if bullet == current_bullet:
		current_bullet = null
