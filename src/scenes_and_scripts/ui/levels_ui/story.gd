extends Control
class_name Story


@onready var next_msg_button: Button = $UI/HBoxContainer/NextMsgButton
@onready var skip_button: Button = $UI/HBoxContainer/SkipButton

@export var parts: Dictionary[String, StoryPart] = {}
@export var chars_per_second: float = 25

signal _message_interrupt(val: String)


func _ready() -> void:
	visible = false


func play_part(part: String) -> void:
	if not part in parts:
		return
	var story_part: StoryPart = parts[part]
	visible = true
	story_part.visible = true
	get_tree().paused = true
	for msg: RichTextLabel in story_part.messages:
		msg.visible = false
	for msg: RichTextLabel in story_part.messages:
		msg.visible = true
		msg.visible_characters = 0
		skip_button.visible = true
		next_msg_button.visible = false
		skip_button.grab_focus()
		var tween: Tween = create_tween()
		tween.tween_property(msg, "visible_characters", len(msg.text), len(msg.text) / chars_per_second)
		tween.finished.connect(_on_tween_finished)
		while true:
			var intr: String = await _message_interrupt
			if intr == "exit":
				get_tree().paused = false
				story_part.visible = false
				visible = false
				return
			elif intr == "skip":
				skip_button.visible = false
				next_msg_button.visible = true
				tween.kill()
				msg.visible_characters = -1
				next_msg_button.grab_focus()
			elif intr == "next":
				break
		msg.visible = false
	get_tree().paused = false
	story_part.visible = false
	visible = false

func _on_tween_finished() -> void:
	_message_interrupt.emit("skip")

func _on_next_msg_button_pressed() -> void:
	_message_interrupt.emit("next")

func _on_exit_button_pressed() -> void:
	_message_interrupt.emit("exit")

func _on_skip_button_pressed() -> void:
	_message_interrupt.emit("skip")
