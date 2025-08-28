extends Node
class_name StateMachine


@export var player: Player
@export var state: State

@export var walk: StateWalk
@export var fall: StateFall
@export var dash: StateDash
@export var climb: StateClimb

@export var raycast_left: RayCast2D
@export var raycast_right: RayCast2D

const MAX_JUMP_BUFFER: int = 8
var jump_buffer: int = 0

const MAX_ON_FLOOR_BUFFER: int = 10
var on_floor_buffer: int = 0

var disable_climb: bool = false

@onready var state_display: RichTextLabel = $"../StateDisplay"


func _ready() -> void:
	state_display.text = state.name

func _process(delta: float) -> void:
	if state:
		jump_buffer -= 1
		if Input.is_action_just_pressed("jump"):
			jump_buffer = MAX_JUMP_BUFFER
		
		on_floor_buffer -= 1
		if player.is_on_floor():
			on_floor_buffer = MAX_ON_FLOOR_BUFFER
		
		if not raycast_left.is_colliding() and not raycast_right.is_colliding():
			disable_climb = false
		
		var new_state: State = state.process(delta)
		if new_state && (not disable_climb || new_state != climb):
			state = new_state
			state_display.text = state.name
