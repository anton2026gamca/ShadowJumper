@tool
extends State
class_name PlayerWallClimb


@export var controller: PlayerController
@export var cimb_particles: CPUParticles2D


func process(_delta: float) -> Variant:
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	if controller.is_on_floor():
		return PlayerWalk
	var left: bool = controller.climb_left_raycast.get_collider() is TileMapLayer
	var right: bool = controller.climb_right_raycast.get_collider() is TileMapLayer
	if not left and not right:
		return PlayerFall
	var dir: int = -1 if left else (1 if right else 0)
	if controller.get_jump_buffered():
		controller.target.velocity.x = -dir * controller.speed
		controller.jump()
		controller.disable_climb = true
		return PlayerFall
	if (controller.get_move_left() if right else controller.get_move_right()):
		controller.last_on_floor_time = 0
		controller.disable_climb = true
		return PlayerFall
	controller.target.velocity.y = controller.climb_down_velocity
	
	if cimb_particles:
		cimb_particles.position.x = dir * abs(cimb_particles.position.x)
		cimb_particles.emitting = true
	
	return null


func on_exit() -> void:
	if cimb_particles: cimb_particles.emitting = false
