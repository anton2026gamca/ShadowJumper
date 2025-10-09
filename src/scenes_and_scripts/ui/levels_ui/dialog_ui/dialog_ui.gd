extends Control
class_name DialogUI


@export_group("References")

@onready var buttons_container: HBoxContainer = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer
@onready var next_msg_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/NextMsgButton
@onready var skip_button: Button = $UI/Panel/HBoxContainer/VBoxContainer/HBoxContainer/SkipButton
@onready var typing_sound: AudioStreamPlayer = $UI/TypingSound

@onready var npc_sprite: TextureRect = $UI/Panel/HBoxContainer/NPCSprite
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
	
	npc_sprite.texture = dialog.character_default_sprite
	character_name.text = dialog.character_name
	character_name.add_theme_color_override("font_color", dialog.character_name_color)
	
	for msg: NPCDialogMessage in dialog.messages:
		await _play_message(dialog, msg)
	
	create_tween().tween_property(Music, "volume_linear", music_volume_before, 1)
	get_tree().paused = false
	visible = false
	dialog_finished.emit()

func _play_message(dialog: NPCDialog, msg: NPCDialogMessage) -> void:
	npc_sprite.texture = msg.character_sprite_override if msg.character_sprite_override else dialog.character_default_sprite
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
		for answer: NPCDialogAnswer in msg.answers:
			var answer_option: AnswerOption = answer_scene.instantiate()
			answer_option.text = answer.text
			answer_option.dialog_answer = answer
			answer_option.button.pressed.connect(_on_answer_pressed.bind(answer_option))
			answer_option.button.focus_entered.connect(_selected_answer_changed.bind(answer_option, msg, dialog))
			answers_container.add_child(answer_option)
	
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
				if answers_container.get_child(0): answers_container.get_child(0).grab_focus()
				buttons_container.visible = false
		elif intr[0] == "next":
			break
		elif msg is NPCDialogAnswerMessage and intr[0] == "answer_selected" and len(intr) >= 2 and intr[1] is AnswerOption:
			var answer_option: AnswerOption = intr[1]
			msg.answer_picked.emit(answer_option.dialog_answer)
			for sub_msg: NPCDialogMessage in answer_option.dialog_answer.next_messages:
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

func _on_answer_pressed(answer_option: AnswerOption) -> void:
	_message_interrupt.emit(["answer_selected", answer_option])

func _selected_answer_changed(answer_option: AnswerOption, msg: NPCDialogMessage, dialog: NPCDialog) -> void:
	if answer_option.dialog_answer.npc_sprite_override:
		npc_sprite.texture = answer_option.dialog_answer.npc_sprite_override
	else:
		npc_sprite.texture = msg.character_sprite_override if msg.character_sprite_override else dialog.character_default_sprite
