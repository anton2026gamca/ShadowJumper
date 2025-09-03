@tool
extends PlayerController
class_name ReplayPlayerController


@export var state_machine: StateMachine

@export_tool_button("Start/Stop Recording") var record_btn: Callable = start_stop_recording
var is_recording: bool = false

@export var replay_data: PlayerReplayData

@export_tool_button("Replay") var replay_btn: Callable = start_replay
var replay_start_target_pos: Vector2 = Vector2.ZERO
var is_replaying: bool = false
var current_frame_data_index: int = 0
var current_frame_data: PlayerReplayFrameData
var current_frame_index_in_data: int = 0

@export var reset_position_after_replay: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		InputMap.load_from_project_settings()

func _physics_process(delta: float) -> void:
	if is_recording:
		const functions: Array[String] = ["get_move_left", "get_move_right", "get_move_dir", "get_jump", "get_jump_released", "get_jump_buffered", "get_dash", "is_on_floor", "is_on_floor_buffered"]
		var function_returns: Dictionary[String, Variant] = {}
		for fun: String in functions:
			function_returns[fun] = Callable(self, fun).call()
		
		var done: bool = false
		if len(replay_data.data) > 0:
			var last: PlayerReplayFrameData = replay_data.data[len(replay_data.data) - 1]
			if last.data == function_returns:
				last.frames_count += 1
				done = true
		if not done:
			var frame_data: PlayerReplayFrameData = PlayerReplayFrameData.new()
			frame_data.frames_count = 1
			frame_data.data = function_returns
			replay_data.data.append(frame_data)
	elif is_replaying:
		replay_next_frame.call_deferred()

func replay_next_frame() -> void:
	current_frame_index_in_data += 1
	if current_frame_index_in_data >= current_frame_data.frames_count:
		current_frame_index_in_data = 0
		current_frame_data_index += 1
		if current_frame_data_index >= len(replay_data.data):
			is_replaying = false
			target.enable_in_editor = false
			state_machine.enable_in_editor = false
			if reset_position_after_replay:
				target.position = replay_start_target_pos
			print("Finished replaying")
			return
		print("Replaying frame data ", current_frame_data_index)
		current_frame_data = replay_data.data[current_frame_data_index]


func start_stop_recording() -> void:
	if not target or not state_machine:
		return
	if not is_recording:
		print("Starting recording")
		is_recording = true
		if not replay_data:
			replay_data = PlayerReplayData.new()
		replay_data.start_pos = target.position
		replay_data.data = []
		
		target.enable_in_editor = true
		state_machine.enable_in_editor = true
	else:
		print("Stopping recording")
		is_recording = false
		target.enable_in_editor = false
		state_machine.enable_in_editor = false
		target.position = replay_data.start_pos
		var len: int = len(replay_data.data)
		replay_data.data[len - 1].frames_count = 1
		replay_data.data[0].frames_count = 1

func start_replay() -> void:
	if is_recording or not replay_data or not replay_data.data:
		return
	print("Started replay")
	is_replaying = true
	current_frame_data_index = 0
	current_frame_index_in_data = 0
	current_frame_data = replay_data.data[current_frame_data_index]
	replay_start_target_pos = target.position
	target.position = replay_data.start_pos
	target.enable_in_editor = true
	state_machine.enable_in_editor = true


func get_move_left() -> bool:
	if is_recording:
		return Input.is_action_pressed("move_left")
	if is_replaying:
		return current_frame_data.data["get_move_left"]
	return false

func get_move_right() -> bool:
	if is_recording:
		return Input.is_action_pressed("move_right")
	if is_replaying:
		return current_frame_data.data["get_move_right"]
	return false

func get_move_dir() -> float:
	if is_recording:
		return Input.get_axis("move_left", "move_right")
	if is_replaying:
		return current_frame_data.data["get_move_dir"]
	return 0

func get_jump() -> bool:
	if is_recording:
		return Input.is_action_just_pressed("jump") and not disable_jump
	if is_replaying:
		return current_frame_data.data["get_jump"]
	return false

func get_jump_released() -> bool:
	if is_recording:
		return Input.is_action_just_released("jump")
	if is_replaying:
		return current_frame_data.data["get_jump_released"]
	return false

func get_jump_buffered() -> bool:
	if is_replaying:
		return current_frame_data.data["get_jump_buffered"]
	return super.get_jump_buffered()

func get_dash() -> bool:
	if is_recording:
		return Input.is_action_pressed("dash")
	if is_replaying:
		return current_frame_data.data["get_dash"]
	return false

func is_on_floor() -> bool:
	if is_replaying:
		return current_frame_data.data["is_on_floor"]
	return super.is_on_floor()

func is_on_floor_buffered() -> bool:
	if is_replaying:
		return current_frame_data.data["is_on_floor_buffered"]
	return super.is_on_floor_buffered()
