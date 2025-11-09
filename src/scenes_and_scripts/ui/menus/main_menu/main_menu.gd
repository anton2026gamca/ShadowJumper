@tool
extends Menu
class_name MainMenu


@export var settings_menu: Menu
@export var controls_menu: Menu

@onready var lang_to_btn: Dictionary[String, Button] = {
	"en": $ControlToggleLanguage/HBoxContainer/LanguageEnglish,
	"ja": $ControlToggleLanguage/HBoxContainer/LanguageJapanese,
}


func _ready() -> void:
	change_language("en")

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_controls_pressed() -> void:
	open_sub_menu(controls_menu)

func change_language(lang: String) -> void:
	TranslationServer.set_locale(lang)
	for btn: Button in lang_to_btn.values():
		btn.disabled = false
	if not lang in lang_to_btn:
		return
	lang_to_btn[lang].disabled = true
