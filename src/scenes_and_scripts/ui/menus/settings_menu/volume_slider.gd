@tool
extends Control
class_name VolumeSlider


@export var audio_bus: StringName
@export var label: String:
	set(value):
		if label_node: label_node.text = value
		label = value
	get: return label

@onready var label_node: RichTextLabel = $RichTextLabel
@onready var value_text: RichTextLabel = $Value

signal value_changed(value: float)


func _ready() -> void:
	label_node.text = label


func _on_slider_value_changed(value: float) -> void:
	value_text.text = str(int(value)) + "%"
	value_changed.emit(value)
	var idx: int = AudioServer.get_bus_index(audio_bus)
	if idx < 0: return
	AudioServer.set_bus_volume_linear(idx, value / 100.0)
