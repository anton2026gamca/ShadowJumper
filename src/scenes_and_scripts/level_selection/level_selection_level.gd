@tool
extends Node2D
class_name LevelSelectionLevel


@export var number: int:
	set(value):
		number = value
		update_label()
	get: return number
@onready var label: Label = $Label
@export var label_text: String = "Level ${number}":
	set(value):
		label_text = value
		update_label()
	get: return label_text
func update_label():
	if not label: return
	label.text = label_text.replace("${number}", str(number))

@export_group("Relationships")
@export var level_up: LevelSelectionLevel
@export var level_down: LevelSelectionLevel
@export var level_left: LevelSelectionLevel
@export var level_right: LevelSelectionLevel


func _ready() -> void:
	update_label()
