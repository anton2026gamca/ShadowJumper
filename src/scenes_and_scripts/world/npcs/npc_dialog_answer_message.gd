extends NPCDialogMessage
class_name NPCDialogAnswerMessage


@export var answers: Array[NPCDialogAnswer] = []
signal answer_picked(answer_index: int)
