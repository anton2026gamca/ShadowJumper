extends Bullet
class_name BeeBulet


@onready var sprite: Sprite2D = $Sprite2D
@export var turn_back_rate: Curve
@export var homing_rate: float = 100.0
var initial_homing_dir: float = 0.0

var target: Node2D


func _physics_process(delta: float) -> void:
	velocity.y -= turn_back_rate.sample(velocity.y) * delta
	if abs(target.position.x - position.x) > 4.0:
		var dir: int = Vector2(target.position.x - position.x, 0).normalized().x
		velocity.x = move_toward(velocity.x, dir * homing_rate, 15)
		if initial_homing_dir == 0:
			initial_homing_dir = dir
	elif initial_homing_dir + Vector2(velocity.x, 0).normalized().x > 0:
		velocity.x = move_toward(velocity.x, 0, 5)
	rotation = velocity.angle() + PI / 2
	move_and_slide()
