extends State
class_name AnimalSearching


@onready var target: Animal = $"../.."
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var raycasts: Node2D = $"../../Raycasts"

@onready var ground: RayCast2D = $"../../Raycasts/Ground"
@onready var wall: RayCast2D = $"../../Raycasts/Wall"
@onready var enemy_area: Area2D = $"../../Raycasts/EnemyArea"

@onready var attacking_audio: AudioStreamPlayer2D = $"../../AttackingAudio"


func process(delta: float) -> String:
	if not ground.is_colliding() or wall.is_colliding():
		sprite.flip_h = not sprite.flip_h
	
	var dir: int = -1 if sprite.flip_h else 1
	raycasts.scale.x = dir
	
	target.velocity.x = target.get_walk_speed() * dir * delta
	if target.is_on_floor(): target.velocity.y = 0
	target.velocity.y += target.get_gravity().y * 2 * delta
	
	sprite.play("move", 0.5)
	
	if enemy_area.monitoring and enemy_area.get_overlapping_bodies().find_custom(func(body: Node2D) -> bool: return body is Player) >= 0:
		attacking_audio.play()
		attacking_audio.pitch_scale = randf() / 5.0 + 0.75
		return "Attacking"
	
	return ""
