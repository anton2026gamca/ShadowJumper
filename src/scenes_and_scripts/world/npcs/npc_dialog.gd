extends Resource
class_name NPCDialog


@export var character_sprite: Texture2D
@export var character_name: String
@export var character_name_color: Color = Color.LIGHT_BLUE
@export_multiline var messages: Array[String]
