@tool
extends Control
class_name VolumeSlider


@export var audio_bus: StringName
@export var label: String:
	set(value):
		if label_node: label_node.text = tr(value)
		label = value
	get: return label

@onready var label_node: RichTextLabel = $RichTextLabel
@onready var value_text: RichTextLabel = $Value
@onready var slider: HSlider = $HSlider

signal value_changed(value: float)

var value: float:
	set(val): slider.value = val
	get: return slider.value


func _ready() -> void:
	label_node.text = tr(label)


@warning_ignore("shadowed_variable")
func set_volume(value: float) -> void:
	value_text.text = str(int(value)) + "%"
	value_changed.emit(value)
	var idx: int = AudioServer.get_bus_index(audio_bus)
	if idx < 0: return
	AudioServer.set_bus_volume_linear(idx, value / 100.0)
