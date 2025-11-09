extends PanelContainer
class_name IdleTimeoutWarning


@onready var timer_label: Label = $VBoxContainer/HBoxContainer/MarginContainer/TimerLabel
@export var warning_threshold: float = 5.0
@export var show_warning: bool = true

var is_showing: bool = false


func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if not show_warning:
		visible = false
		return
	if not IdleTimeout:
		visible = false
		return
	var idle_timeout = IdleTimeout
	var remaining: float = idle_timeout.get_remaining_time()
	if remaining > 0 and remaining <= warning_threshold:
		if not is_showing:
			show_timeout_warning()
			is_showing = true
		if timer_label:
			var time_str = str(int(ceil(remaining)))
			timer_label.text = time_str
	else:
		if is_showing:
			hide_timeout_warning()
			is_showing = false


func show_timeout_warning() -> void:
	visible = true
	modulate.a = 0
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func hide_timeout_warning() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	visible = false
