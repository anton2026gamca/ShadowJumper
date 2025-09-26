@tool
extends State
class_name PlayerWalk


@export var controller: PlayerController


func process(_delta: float) -> Variant:
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	if controller.get_jump_buffered():
		controller.jump()
	
	var direction: float = controller.get_move_dir()
	if direction:
		controller.target.velocity.x = direction * controller.speed
	else:
		controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 100)
	
	if controller.is_on_floor_buffered() and controller.get_dash() and direction:
		controller.target.velocity = Vector2(direction * controller.dash_velocity, 0)
		controller.play_sfx(controller.sfx_dash)
		return PlayerDash
	if not controller.target.is_on_floor():
		return PlayerFall
	return null
