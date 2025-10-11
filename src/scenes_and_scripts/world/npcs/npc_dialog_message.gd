extends Resource
class_name NPCDialogMessage


signal message_started
signal message_finished

@export var character_sprite_override: Texture2D
@export_multiline var message: String
