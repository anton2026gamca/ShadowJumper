extends State
class_name BeeNotInRange


@export var target: Bee

var enemy: Node2D

@export var attack_start_area: Area2D
@export var sprite: AnimatedSprite2D


func process(delta: float) -> Variant:
	if not enemy:
		enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")
		if not enemy: return null
	if attack_start_area.get_overlapping_bodies().has(enemy):
		target.velocity = Vector2.ZERO
		return BeeAttacking
	target.velocity = (enemy.global_position - target.global_position).normalized() * target.fly_speed
	sprite.flip_h = target.velocity.x > 0
	return null


func on_enter() -> void:
	enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")
