extends Resource
class_name NPCDialogAnswer


@export_multiline var text: String = ""
@export var next_messages: Array[NPCDialogMessage] = []
@export var npc_sprite_override: Texture2D
