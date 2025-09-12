extends Sprite2D
class_name Mushroom


@onready var point_light: PointLight = $PointLight

@export var down_time: float = 5.0
var hit_val: int = 0
@export var boom_tolerance_time: float = 0.5

@onready var boom: AnimatedSprite2D = $Boom
var boom_state: int = 0
signal boom_finished

@onready var boom_start_audio: AudioStreamPlayer2D = $BoomStartAudio
@onready var boom_audio: AudioStreamPlayer2D = $BoomAudio


var is_on:
	set(value): return
	get: return point_light.is_on


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if boom_state == 1:
		boom.rotate(deg_to_rad(22.5))


func hit() -> void:
	if point_light.is_on:
		point_light.turn_off()
	hit_val += 1
	var my_hit_val: float = hit_val
	await get_tree().create_timer(down_time).timeout
	if hit_val == my_hit_val:
		point_light.turn_on()
		hit_val = 0

func start_making_boom() -> void:
	if boom_state != 0:
		return
	boom.animation = "boom"
	boom.frame = 1
	boom.rotation = 0
	boom_state = 1
	boom_start_audio.play()

func update_boom(time: float) -> bool:
	if time > boom_tolerance_time and boom_state == 1:
		boom.rotation = 0
		boom.play("boom")
		boom_state = 2
		boom_audio.play()
		await boom.animation_finished
		stop_making_boom()
		return true
	return false

func stop_making_boom() -> void:
	boom_state = 0
	boom.frame = 0
	boom_start_audio.stop()
	boom_audio.stop()
