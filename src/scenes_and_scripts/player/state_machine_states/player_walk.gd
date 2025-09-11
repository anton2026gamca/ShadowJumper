@tool
extends State
class_name PlayerWalk


@export var controller: PlayerController


func process(_delta: float) -> String:
	var is_in_light: bool = false
	for light_source: Node2D in controller.target.light_sources:
		if light_source.get_parent() is Mushroom and light_source.get_parent().is_on:
			is_in_light = true
			break
	
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	if controller.get_jump_buffered():
		controller.target.velocity.y = controller.jump_velocity
		controller.disable_jump = true
		controller.play_sfx(controller.sfx_jump)
		if is_in_light:
			controller.target.die("You jumped in light!\nThe mushroom saw you! :o")
	
	var direction: float = controller.get_move_dir()
	if direction:
		controller.target.velocity.x = direction * controller.speed
		if is_in_light:
			controller.target.die("You moved in light!\nThe mushroom saw you! :o")
	else:
		controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 100)
	
	if controller.is_on_floor_buffered() and controller.get_dash() and direction:
		controller.target.velocity = Vector2(direction * controller.dash_velocity, 0)
		controller.play_sfx(controller.sfx_dash)
		return "PlayerDash"
	if not controller.target.is_on_floor():
		return "PlayerFall"
	return ""
