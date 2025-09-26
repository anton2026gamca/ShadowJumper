@tool
extends State
class_name PlayerLadderClimb


@export var controller: PlayerController


func process(_delta: float) -> Variant:
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	var x_dir: int = controller.get_move_dir()
	var y_dir: int = controller.get_climb_ladder_dir()
	if x_dir: controller.target.velocity.x = controller.ladder_climb_speed * x_dir
	else: controller.target.velocity.x = 0
	if y_dir: controller.target.velocity.y = controller.ladder_climb_speed * y_dir
	else: controller.target.velocity.y = 0
	if len(controller.climb_ladder_area.get_overlapping_bodies()) == 0:
		return PlayerFall
	return null
