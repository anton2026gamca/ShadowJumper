extends Control
class_name DialogUI


@export_group("References")

@onready var buttons_container: HBoxContainer = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer
@onready var next_msg_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/NextMsgButton
@onready var skip_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/SkipButton
@onready var typing_sound: AudioStreamPlayer = $UI/TypingSound

@onready var sprite: TextureRect = $UI/Panel/HBoxContainer/Sprite
@onready var character_name: Label = $UI/Panel/HBoxContainer/VBoxContainer/CharacterName
@onready var message_text: RichTextLabel = $UI/Panel/HBoxContainer/VBoxContainer/VBoxContainer/MessageText

@onready var answers_container: VBoxContainer = $UI/Panel/HBoxContainer/VBoxContainer/VBoxContainer/MarginContainer/Answers
@export var answer_scene: PackedScene


@export_group("")
@export var chars_per_second: float = 25

signal _message_interrupt(args: Array)
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
		await _play_message(dialog, msg)
	
	create_tween().tween_property(Music, "volume_linear", music_volume_before, 1)
	get_tree().paused = false
	visible = false
	dialog_finished.emit()

func _play_message(dialog: NPCDialog, msg: NPCDialogMessage) -> void:
	sprite.texture = msg.character_sprite_override if msg.character_sprite_override else dialog.character_default_sprite
	message_text.text = msg.message
	message_text.visible_characters = 0
	buttons_container.visible = true
	skip_button.visible = true
	next_msg_button.visible = false
	skip_button.grab_focus()
	answers_container.visible = false
	
	if msg is NPCDialogAnswerMessage:
		for child in answers_container.get_children():
			answers_container.remove_child(child)
			child.queue_free()
		for i: int in len(msg.answers):
			var answer_node: Button = answer_scene.instantiate()
			answer_node.text = msg.answers[i].text
			answer_node.pressed.connect(_on_answer_selected.bind(i))
			answers_container.add_child(answer_node)
	
	var tween: Tween = create_tween()
	tween.tween_property(message_text, "visible_characters", message_text.get_parsed_text().length(), message_text.get_parsed_text().length() / chars_per_second)
	tween.finished.connect(_on_tween_finished)
	typing_sound.play()
	
	while true:
		var intr: Array = await _message_interrupt
		if len(intr) == 0: continue
		if intr[0] == "exit":
			typing_sound.stop()
			return
		elif intr[0] == "skip":
			skip_button.visible = false
			next_msg_button.visible = true
			tween.kill()
			message_text.visible_characters = -1
			next_msg_button.grab_focus()
			typing_sound.stop()
			if msg is NPCDialogAnswerMessage:
				answers_container.visible = true
				answers_container.get_child(0).grab_focus()
				buttons_container.visible = false
		elif intr[0] == "next":
			break
		elif msg is NPCDialogAnswerMessage and intr[0] == "answer_selected" and len(intr) >= 2 and intr[1] is int:
			var answer_index: int = intr[1]
			msg.answer_picked.emit(answer_index)
			for sub_msg: NPCDialogMessage in msg.answers[answer_index].next_messages:
				await _play_message(dialog, sub_msg)
			break


func _on_tween_finished() -> void:
	_message_interrupt.emit(["skip"])

func _on_next_msg_button_pressed() -> void:
	_message_interrupt.emit(["next"])

func _on_exit_button_pressed() -> void:
	_message_interrupt.emit(["exit"])

func _on_skip_button_pressed() -> void:
	_message_interrupt.emit(["skip"])

func _on_answer_selected(answer_index: int) -> void:
	_message_interrupt.emit(["answer_selected", answer_index])
