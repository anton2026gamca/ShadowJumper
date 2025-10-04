extends Control
class_name DialogUI


@onready var next_msg_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/NextMsgButton
@onready var skip_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/SkipButton
@onready var typing_sound: AudioStreamPlayer = $UI/TypingSound

@onready var sprite: TextureRect = $UI/Panel/HBoxContainer/Sprite
@onready var character_name: Label = $UI/Panel/HBoxContainer/VBoxContainer/CharacterName
@onready var message_text: RichTextLabel = $UI/Panel/HBoxContainer/VBoxContainer/MessageText

@export var chars_per_second: float = 25

signal _message_interrupt(val: String)
signal dialog_finished


func _ready() -> void:
	visible = false


func play_dialog(dialog: NPCDialog) -> void:
	if not dialog:
		return
	await get_tree().process_frame
	visible = true
	get_tree().paused = true
	
	var music_volume_before: float = Music.volume_linear
	create_tween().tween_property(Music, "volume_linear", 0.05, 1)
	
	sprite.texture = dialog.character_default_sprite
	character_name.text = dialog.character_name
	character_name.add_theme_color_override("font_color", dialog.character_name_color)
	
	for msg: NPCDialogMessage in dialog.messages:
		sprite.texture = msg.character_sprite_override if msg.character_sprite_override else dialog.character_default_sprite
		message_text.text = msg.message
		message_text.visible_characters = 0
		skip_button.visible = true
		next_msg_button.visible = false
		skip_button.grab_focus()
		
		var tween: Tween = create_tween()
		tween.tween_property(message_text, "visible_characters", message_text.get_parsed_text().length(), message_text.get_parsed_text().length() / chars_per_second)
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
				message_text.visible_characters = -1
				next_msg_button.grab_focus()
				typing_sound.stop()
			elif intr == "next":
				break
		if exit: break
	
	create_tween().tween_property(Music, "volume_linear", music_volume_before, 1)
	get_tree().paused = false
	visible = false
	dialog_finished.emit()

func _on_tween_finished() -> void:
	_message_interrupt.emit("skip")

func _on_next_msg_button_pressed() -> void:
	_message_interrupt.emit("next")

func _on_exit_button_pressed() -> void:
	_message_interrupt.emit("exit")

func _on_skip_button_pressed() -> void:
	_message_interrupt.emit("skip")
