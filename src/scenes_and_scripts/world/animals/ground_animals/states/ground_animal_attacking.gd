extends State
class_name GroundAnimalAttacking


@export var target: GroundAnimal
@export var sprite: AnimatedSprite2D

@export_group("Physics")
@export var physics_parent: Node2D
@export var enemy_area: Area2D
@export var ground: RayCast2D
@export var wall: RayCast2D
@export var hit_start_area: Area2D
@export var hit_range_area: Area2D

@export_group("SFX")
@export var attacking_audio: AudioStreamPlayer2D
@export var attack_audio: AudioStreamPlayer2D

@export_group("Effects")
@export var attack_particles: CPUParticles2D

var paused: bool = false


func process(delta: float) -> Variant:
	if paused:
		return null
	var bodies: Array[Node2D] = enemy_area.get_overlapping_bodies()
	var player_index: int = bodies.find_custom(func(body: Node2D) -> bool: return body is Player)
	if player_index < 0:
		return GroundAnimalSearching
	var player: Player = bodies[player_index]
	
	
	
	if not ground.is_colliding() or wall.is_colliding():
		sprite.play("idle")
		target.velocity.x = 0
		target.velocity.y += target.get_gravity().y * 2 * delta
		if randf() / 2.0 <= target.chance_to_give_up:
			return give_up()
	else:
		sprite.play("move", 1.5)
		var dir: int = Vector2(player.position.x - target.position.x, 0.0).normalized().x
		sprite.flip_h = dir < 0
		physics_parent.scale.x = dir
		target.velocity.x = target.get_run_speed() * dir * delta
		target.velocity.y += target.get_gravity().y * 2 * delta
		if randf() <= target.chance_to_give_up:
			return give_up()
	
	if hit_start_area.get_overlapping_bodies().has(player):
		attack(player)
	
	return null

func on_enter() -> void:
	attacking_audio.finished.connect(play_attacking_audio)

func on_exit() -> void:
	attacking_audio.finished.disconnect(play_attacking_audio)


func attack(player: Player) -> void:
	sprite.play("attack")
	attack_audio.pitch_scale = randf_range(0.8, 1.2)
	attack_audio.play()
	attack_particles.position.x = (-1 if sprite.flip_h else 1) * abs(attack_particles.position.x)
	attack_particles.direction.x = (-1 if sprite.flip_h else 1) * abs(attack_particles.direction.x)
	attack_particles.emitting = true
	paused = true
	await sprite.animation_finished
	paused = false
	if hit_range_area.get_overlapping_bodies().has(player):
		var death_component: DeathComponent = Helpers.find_child_by_type(player, DeathComponent)
		if death_component:
			death_component.die(target.get_player_die_reason())

func give_up() -> Variant:
	enemy_area.monitoring = false
	sprite.flip_h = not sprite.flip_h
	get_tree().create_timer(target.give_up_time).timeout.connect(resume_monitoring)
	return GroundAnimalSearching

func play_attacking_audio() -> void:
	attacking_audio.play()
	attacking_audio.pitch_scale = randf() / 5.0 + 0.75

func resume_monitoring() -> void:
	enemy_area.monitoring = true
