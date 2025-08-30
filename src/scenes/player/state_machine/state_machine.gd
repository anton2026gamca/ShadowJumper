extends Node
class_name StateMachine

@export var player: Player
@export var state: State

@export_group("States")
@export var walk: StateWalk
@export var fall: StateFall
@export var dash: StateDash
@export var climb: StateClimb

@export_group("Physics")
@export var raycast_left: RayCast2D
@export var raycast_right: RayCast2D

@export_group("SFX")
@export var sfx_jump: AudioStream
@export var sfx_dash: AudioStream

const MAX_JUMP_BUFFER: float = 80
var jump_buffer: float = 0

var disable_jump: bool = false

const MAX_ON_FLOOR_BUFFER: float = 100
var on_floor_buffer: float = 0

var disable_climb: bool = false

@onready var state_display: RichTextLabel = $"../StateDisplay"


func _ready() -> void:
	state_display.text = state.name

func _process(delta: float) -> void:
	if state:
		jump_buffer = max(jump_buffer - delta * 1000, 0)
		if Input.is_action_just_pressed("jump"):
			jump_buffer = MAX_JUMP_BUFFER
		
		on_floor_buffer = max(on_floor_buffer - delta * 1000, 0)
		if player.is_on_floor():
			on_floor_buffer = MAX_ON_FLOOR_BUFFER
		
		if not raycast_left.is_colliding() and not raycast_right.is_colliding():
			disable_climb = false
		
		var new_state: State = state.process(delta)
		if new_state:
			state = new_state
			state_display.text = state.name


func play_sfx(sfx: AudioStream) -> void:
	var pl: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	pl.stream = sfx
	pl.autoplay = true
	pl.pitch_scale = (randf() / 8.0) + (1.0 - (1.0 / 8.0) / 2.0)
	player.add_child(pl)
	await pl.finished
	player.remove_child(pl)
