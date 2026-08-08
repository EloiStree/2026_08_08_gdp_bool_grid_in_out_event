class_name BoolGridUiTextCodeChanged
extends Node


signal on_text_changed(text_image: String)

@export var _text_edit: TextEdit


func _ready() -> void:
	if _text_edit == null:
		return
	_text_edit.text_changed.connect(Callable(self, "_on_text_changed"))


func _on_text_changed() -> void:
	if _text_edit == null:
		return
	on_text_changed.emit(_text_edit.text)
