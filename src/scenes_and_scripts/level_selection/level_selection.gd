extends Node2D


@export var current_level: LevelSelectionLevel

@onready var player: Sprite2D = $Player


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") && current_level.level_up:
		move_to_level(current_level.level_up)
	if Input.is_action_just_pressed("ui_down") && current_level.level_down:
		move_to_level(current_level.level_down)
	if Input.is_action_just_pressed("ui_left") && current_level.level_left:
		move_to_level(current_level.level_left)
	if Input.is_action_just_pressed("ui_right") && current_level.level_right:
		move_to_level(current_level.level_right)


func move_to_level(level: LevelSelectionLevel) -> void:
	current_level = level
