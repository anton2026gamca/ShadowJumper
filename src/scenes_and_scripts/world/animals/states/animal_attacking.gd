extends State
class_name AnimalAttacking


@onready var target: Animal = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

@onready var enemy_area: Area2D = $"../../Raycasts/EnemyArea"
@onready var ground: RayCast2D = $"../../Raycasts/Ground"
@onready var wall: RayCast2D = $"../../Raycasts/Wall"
@onready var hit_area: Area2D = $"../../Raycasts/HitArea"
@onready var raycasts: Node2D = $"../../Raycasts"

@onready var attacking_audio: AudioStreamPlayer2D = $"../../AttackingAudio"


func process(delta: float) -> String:
	var bodies: Array[Node2D] = enemy_area.get_overlapping_bodies()
	var player_index: int = bodies.find_custom(func(body: Node2D) -> bool: return body is Player)
	if player_index < 0:
		return "Searching"
	var player: Player = bodies[player_index]
	
	if not ground.is_colliding() or wall.is_colliding():
		sprite.play("idle")
		target.velocity.x = 0
		target.velocity.y += target.get_gravity().y * 2 * delta
	else:
		sprite.play("move")
		var dir: int = Vector2(player.position.x - target.position.x, 0.0).normalized().x
		sprite.flip_h = dir < 0
		raycasts.scale.x = dir
		target.velocity.x = target.get_run_speed() * dir * delta
		target.velocity.y += target.get_gravity().y * 2 * delta
	
	if hit_area.get_overlapping_bodies().has(player):
		player.die(target.get_player_die_reason())
	
	return ""

func on_enter() -> void:
	attacking_audio.finished.connect(play_attacking_audio)

func on_exit() -> void:
	attacking_audio.finished.disconnect(play_attacking_audio)


func play_attacking_audio() -> void:
	attacking_audio.play()
	attacking_audio.pitch_scale = randf() / 5.0 + 0.75
