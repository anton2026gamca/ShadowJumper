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

@export var scene: PackedScene

@export var relationships: Dictionary[Vector2i, LevelSelectionLevel]
@export var player_replays: Dictionary[Vector2i, PlayerReplayData]

var is_completed: bool = false


func _ready() -> void:
	update_label()

func mark_completed() -> void:
	$PointLight2D.enabled = false
	is_completed = true

func mark_uncompleted() -> void:
	$PointLight2D.enabled = true
	is_completed = false
