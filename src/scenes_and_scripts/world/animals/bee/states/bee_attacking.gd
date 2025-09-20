extends State
class_name BeeAttacking


@export var target: Bee

var enemy: Node2D
@export var target_lost_area: Area2D
@export var bullet_scene: PackedScene
@export var bullet_spawner: Node2D

var current_bullet: BeeBulet


func process(delta: float) -> Variant:
	if not enemy:
		enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")
		if not enemy: return null
	if not target_lost_area.get_overlapping_bodies().has(enemy):
		return BeeNotInRange
	
	# TODO: Implement attacking
	
	target.velocity.x = move_toward(target.velocity.x, Vector2.ZERO.x, 20.0)
	target.velocity.y = move_toward(target.velocity.y, Vector2.ZERO.y, 20.0)
	
	if not current_bullet:
		current_bullet = bullet_scene.instantiate()
		current_bullet.global_position = bullet_spawner.global_position
		current_bullet.rotation_degrees = 180
		current_bullet.target = enemy
		current_bullet.finished.connect(_on_bullet_finished)
		get_parent().add_child(current_bullet)
	
	return null

func on_enter() -> void:
	enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")


func _on_bullet_finished() -> void:
	current_bullet = null
