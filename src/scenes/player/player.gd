extends CharacterBody2D
class_name Player


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const MAX_FALL_VELOCITY = 750.0
const DASH_VELOCITY = 2000.0
const CLIMB_DOWN_VELOCITY = 50.0


@warning_ignore("shadowed_variable_base_class")
func apply_gravity(delta: float, scale: float = 1.0) -> void:
	velocity += get_gravity() * delta * scale
	velocity.y = min(velocity.y, MAX_FALL_VELOCITY)
