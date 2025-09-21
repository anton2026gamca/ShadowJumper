extends Sprite2D
class_name Mushroom


@export var die_reason: String = "You were electrified by a mushroom :o"

@onready var point_light: PointLight = $PointLight

@export var down_time: float = 5.0
var hit_val: int = 0

@onready var boom_sprite: AnimatedSprite2D = $Boom
@onready var boom_area: Area2D = $Area2D
@export var boom_tolerance_time: float = 0.5
var boom_state: int = 0
var boom_target: Player
var boom_angry_value: float = 0.0
signal boom_finished

@onready var boom_start_audio: AudioStreamPlayer2D = $BoomStartAudio
@onready var boom_audio: AudioStreamPlayer2D = $BoomAudio
@onready var hit_audio: AudioStreamPlayer2D = $HitAudio
@onready var respawn_audio: AudioStreamPlayer2D = $RespawnAudio

var is_on: bool:
	set(value): return
	get: return point_light.is_on


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on:
		return
	var players: Array[Node2D] = boom_area.get_overlapping_bodies().filter(func(body: Node2D) -> bool: return body is Player)
	var progress: float = 0
	for player: Player in players:
		if player.controller.get_move_dir() or player.controller.get_climb_ladder_dir():
			start_making_boom()
			boom_angry_value += delta
			progress += delta
	if boom_state == 1:
		boom_sprite.rotate(deg_to_rad(22.5))
		if await update_boom():
			for player: Player in players:
				var death_component: DeathComponent = Helpers.find_child_by_type(player, DeathComponent)
				if death_component:
					death_component.die(die_reason)
	if boom_state != 0 and (len(players) == 0 or progress == 0):
		stop_making_boom()


func hit() -> void:
	if is_on:
		point_light.turn_off()
		hit_audio.pitch_scale = randf_range(0.5, 1.5)
		hit_audio.play()
	boom_angry_value = 0
	stop_making_boom()
	hit_val += 1
	var my_hit_val: float = hit_val # Store hit val before pausing to handle multiple hit() calls
	await get_tree().create_timer(down_time).timeout
	if hit_val == my_hit_val: # If hit_val is still the same, turn on. If not, that means hit() was called when waiting (later that this call) and let it handle the turn on.
		respawn_audio.pitch_scale = hit_audio.pitch_scale
		respawn_audio.play()
		point_light.turn_on()
		hit_val = 0

func start_making_boom() -> void:
	if boom_state != 0:
		return
	boom_sprite.animation = "boom"
	boom_sprite.frame = 1
	boom_sprite.rotation = 0
	boom_state = 1
	boom_start_audio.play()

func update_boom() -> bool:
	if boom_angry_value > boom_tolerance_time and boom_state == 1:
		boom_sprite.rotation = 0
		boom_sprite.play("boom")
		boom_state = 2
		boom_audio.play()
		await boom_sprite.animation_finished
		stop_making_boom()
		return true
	return false

func stop_making_boom() -> void:
	boom_state = 0
	boom_sprite.frame = 0
	boom_start_audio.stop()
	boom_audio.stop()
