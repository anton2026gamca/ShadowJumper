extends Bullet
class_name BeeBulet


@onready var sprite: Sprite2D = $Sprite2D
@export var turn_back_rate: Curve
@export var homing_rate_min: float = 80.0
@export var homing_rate_max: float = 120.0
var initial_homing_dir: float = 0.0
var homing_rate: float

var target: Node2D


func _ready() -> void:
	super._ready()
	homing_rate = 100#randf_range(homing_rate_min, homing_rate_max)

func _physics_process(delta: float) -> void:
	if not target:
		move_and_slide()
		return
	velocity.y -= turn_back_rate.sample(velocity.y) * delta
	if abs(target.position.x - position.x) > 4.0:
		var dir: float = Vector2(target.position.x - position.x, 0).normalized().x
		velocity.x = move_toward(velocity.x, dir * homing_rate, 15)
		if initial_homing_dir == 0:
			initial_homing_dir = dir
	elif initial_homing_dir + Vector2(velocity.x, 0).normalized().x > 0:
		velocity.x = move_toward(velocity.x, 0, 5)
	rotation = velocity.angle() + PI / 2
	move_and_slide()
