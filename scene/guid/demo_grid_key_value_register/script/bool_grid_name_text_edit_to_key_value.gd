class_name BoolGridUiGridTextEditToNamedKeyValue
extends Node

signal on_grid_key_value_changed(grid_key_name:String, grid_value:String)

@export var _line_edit_key_name: LineEdit
@export var _text_edit_grid_value: TextEdit
@export var _submit_button: Button

@export var _auto_update_on_change: bool = false

func _ready() -> void:
    if _auto_update_on_change:
        _text_edit_grid_value.text_changed.connect(_on_grid_value_text_changed)
    if _submit_button:
        _submit_button.pressed.connect(submit_grid_key_value)


func submit_grid_key_value() -> void:
    _on_grid_value_text_changed()

func _on_grid_value_text_changed() -> void:
    var key_name = _line_edit_key_name.text.strip_edges()
    if key_name == "":
        return
    var grid_value = _text_edit_grid_value.text.strip_edges()
    if grid_value == "":
        return
    on_grid_key_value_changed.emit(key_name, grid_value)