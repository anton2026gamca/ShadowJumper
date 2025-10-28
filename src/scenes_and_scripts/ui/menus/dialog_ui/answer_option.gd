extends PanelContainer
class_name AnswerOption


@export var rich_text_label: RichTextLabel
@export var button: Button
var dialog_answer: NPCDialogAnswer


var text: String:
	set(value):
		rich_text_label.text = value
		button.text = rich_text_label.get_parsed_text()
	get: return rich_text_label.text


@warning_ignore("native_method_override")
func grab_focus() -> void:
	button.grab_focus()
