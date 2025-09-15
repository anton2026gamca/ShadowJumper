extends State
class_name AnimalAttacking


@onready var target: Animal = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

@onready var enemy_area: Area2D = $"../../Raycasts/EnemyArea"
@onready var ground: RayCast2D = $"../../Raycasts/Ground"
@onready var wall: RayCast2D = $"../../Raycasts/Wall"
@onready var hit_start_area: Area2D = $"../../Raycasts/HitStartArea"
@onready var hit_range_area: Area2D = $"../../Raycasts/HitRangeArea"
@onready var raycasts: Node2D = $"../../Raycasts"

@onready var attacking_audio: AudioStreamPlayer2D = $"../../AttackingAudio"
@onready var attack_audio: AudioStreamPlayer2D = $"../../AttackAudio"

var paused: bool = false

var idle_time: float = 0


func process(delta: float) -> String:
	if paused:
		return ""
	var bodies: Array[Node2D] = enemy_area.get_overlapping_bodies()
	var player_index: int = bodies.find_custom(func(body: Node2D) -> bool: return body is Player)
	if player_index < 0:
		return "Searching"
	var player: Player = bodies[player_index]
	
	if not ground.is_colliding() or wall.is_colliding():
		sprite.play("idle")
		target.velocity.x = 0
		target.velocity.y += target.get_gravity().y * 2 * delta
		idle_time += delta
		if idle_time > 2:
			enemy_area.monitoring = false
			get_tree().create_timer(3.0).timeout.connect(resume_monitoring)
			return "Searching"
	else:
		sprite.play("move", 1.5)
		var dir: int = Vector2(player.position.x - target.position.x, 0.0).normalized().x
		sprite.flip_h = dir < 0
		raycasts.scale.x = dir
		target.velocity.x = target.get_run_speed() * dir * delta
		target.velocity.y += target.get_gravity().y * 2 * delta
		idle_time = 0
	
	if hit_start_area.get_overlapping_bodies().has(player):
		attack(player)
	
	return ""

func on_enter() -> void:
	attacking_audio.finished.connect(play_attacking_audio)

func on_exit() -> void:
	attacking_audio.finished.disconnect(play_attacking_audio)


func attack(player: Player) -> void:
	sprite.play("attack")
	attack_audio.pitch_scale = randf_range(0.8, 1.2)
	attack_audio.play()
	paused = true
	await sprite.animation_finished
	paused = false
	if hit_range_area.get_overlapping_bodies().has(player):
		player.die(target.get_player_die_reason())

func play_attacking_audio() -> void:
	attacking_audio.play()
	attacking_audio.pitch_scale = randf() / 5.0 + 0.75

func resume_monitoring() -> void:
	enemy_area.monitoring = true
