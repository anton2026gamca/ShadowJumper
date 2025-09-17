extends State
class_name GroundAnimalSearching


@export var target: GroundAnimal
@export var sprite: AnimatedSprite2D

@export_group("Physics")
@export var physics_parent: Node2D
@export var ground: RayCast2D
@export var wall: RayCast2D
@export var enemy_area: Area2D

@export_group("SFX")
@export var attacking_audio: AudioStreamPlayer2D


func process(delta: float) -> Variant:
	if not ground.is_colliding() or wall.is_colliding():
		sprite.flip_h = not sprite.flip_h
	
	var dir: int = -1 if sprite.flip_h else 1
	physics_parent.scale.x = dir
	
	target.velocity.x = target.get_walk_speed() * dir * delta
	if target.is_on_floor(): target.velocity.y = 0
	target.velocity.y += target.get_gravity().y * 2 * delta
	
	sprite.play("move", 0.5)
	
	if enemy_area.monitoring and enemy_area.get_overlapping_bodies().find_custom(func(body: Node2D) -> bool: return body is Player) >= 0:
		attacking_audio.play()
		attacking_audio.pitch_scale = randf() / 5.0 + 0.75
		return GroundAnimalAttacking
	
	return null
