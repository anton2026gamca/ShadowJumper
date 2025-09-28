extends Control
class_name LevelSelectionUi


@onready var bottom_right_text: RichTextLabel = $BottomRightText


func _ready() -> void:
	if not OS.is_debug_build():
		bottom_right_text.text = bottom_right_text.text.replace("[color=green]DEBUG BUILD[/color]\nPress [color=lightblue]L[/color] to unlock all levels", "")
