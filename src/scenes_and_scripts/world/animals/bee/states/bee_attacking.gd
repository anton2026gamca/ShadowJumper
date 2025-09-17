extends State
class_name BeeAttacking


@export var target: Bee

var enemy: Node2D
@export var attack_start_area: Area2D


func process(delta: float) -> Variant:
	if not enemy:
		enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")
		if not enemy: return null
	if not attack_start_area.get_overlapping_bodies().has(enemy):
		return BeeNotInRange
	target.velocity = Vector2.ZERO
	
	# TODO: Implement attacking
	
	return null


func on_enter() -> void:
	enemy = Helpers.get_nearest_node_in_group(target.global_position, "Player")
