extends Control
class_name Story


@onready var next_msg_button: Button = $UI/HBoxContainer/NextMsgButton
@onready var skip_button: Button = $UI/HBoxContainer/SkipButton
@onready var typing_sound: AudioStreamPlayer = $UI/TypingSound

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
	var music_volume_before: float = Music.volume_linear
	create_tween().tween_property(Music, "volume_linear", 0.05, 1)
	for msg: RichTextLabel in story_part.messages:
		msg.visible = false
	
	for msg: RichTextLabel in story_part.messages:
		msg.visible = true
		msg.visible_characters = 0
		skip_button.visible = true
		next_msg_button.visible = false
		skip_button.grab_focus()
		var tween: Tween = create_tween()
		tween.tween_property(msg, "visible_characters", msg.get_parsed_text().length(), msg.get_parsed_text().length() / chars_per_second)
		tween.finished.connect(_on_tween_finished)
		typing_sound.play()
		var exit: bool = false
		while true:
			var intr: String = await _message_interrupt
			if intr == "exit":
				exit = true
				typing_sound.stop()
				break
			elif intr == "skip":
				skip_button.visible = false
				next_msg_button.visible = true
				tween.kill()
				msg.visible_characters = -1
				next_msg_button.grab_focus()
				typing_sound.stop()
			elif intr == "next":
				break
		msg.visible = false
		if exit:
			break
	create_tween().tween_property(Music, "volume_linear", music_volume_before, 1)
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
