extends Node
class_name IdleTimeoutManager


@export var idle_timeout_duration: float = 30.0
@export var enabled: bool = true
var started: bool = false

var time_since_last_input: float = 0.0
var has_timed_out: bool = false


func _ready() -> void:
	time_since_last_input = 0.0
	has_timed_out = false

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	if event is InputEventMouseMotion:
		return
	if event is InputEventKey:
		if event.pressed:
			reset_timer()
		return
	if event is InputEventJoypadButton:
		if event.pressed:
			reset_timer()
		return
	if event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.2:
			reset_timer()
		return
	if event is InputEventMouseButton:
		if event.pressed:
			reset_timer()
		return

func _process(delta: float) -> void:
	if not enabled or has_timed_out or not started:
		return
	time_since_last_input += delta
	if time_since_last_input >= idle_timeout_duration:
		trigger_timeout()


func reset_timer() -> void:
	time_since_last_input = 0.0
	has_timed_out = false
	started = true

func trigger_timeout() -> void:
	if has_timed_out:
		return
	has_timed_out = true
	Progress.reset()
	Progress._save()
	if OS.has_feature("web"):
		JavaScriptBridge.eval("location.reload();")
	else:
		get_tree().quit()

func pause_timeout() -> void:
	enabled = false

func resume_timeout() -> void:
	enabled = true
	reset_timer()

func get_remaining_time() -> float:
	if not enabled:
		return -1.0
	return max(0.0, idle_timeout_duration - time_since_last_input)

func is_near_timeout(warning_threshold: float = 10.0) -> bool:
	return get_remaining_time() <= warning_threshold and get_remaining_time() > 0.0
