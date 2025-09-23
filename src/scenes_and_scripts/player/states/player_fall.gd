@tool
extends State
class_name PlayerFall


@export var controller: PlayerController

@onready var fall_audio: AudioStreamPlayer2D = $"../../FallAudio"


func process(delta: float) -> Variant:
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	if controller.is_on_floor():
		controller.disable_jump = false
		return PlayerWalk
	var climb_left: bool = controller.climb_left_raycast.get_collider() is TileMapLayer
	var climb_right: bool = controller.climb_right_raycast.get_collider() is TileMapLayer
	var climb_ladder: bool = len(controller.climb_ladder_area.get_overlapping_bodies()) > 0
	if not climb_left and not climb_right and not climb_ladder:
		controller.disable_climb = false
	if not controller.disable_climb and (climb_left or climb_right):
		controller.disable_jump = false
		return PlayerWallClimb
	if not controller.disable_climb and climb_ladder:
		controller.disable_jump = false
		return PlayerLadderClimb
	var direction: float = controller.get_move_dir()
	if controller.is_on_floor_buffered():
		if controller.get_jump_buffered():
			controller.jump()
		if direction: controller.target.velocity.x = direction * controller.speed
		else: controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 6000 * delta)
	else:
		if direction: controller.target.velocity.x = move_toward(controller.target.velocity.x, direction * controller.speed, 900 * delta)
		else: controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 300 * delta)
	
	if controller.get_jump_released() and controller.target.velocity.y < 0:
		controller.target.velocity.y *= 0.25
	
	controller.apply_gravity(delta, 2 if controller.target.velocity.y > 0 else 1)
	
	if controller.target.velocity.y > 650:
		if not fall_audio.playing:
			fall_audio.play()
	else: fall_audio.stop()
	
	return null

func on_exit() -> void:
	fall_audio.stop()
