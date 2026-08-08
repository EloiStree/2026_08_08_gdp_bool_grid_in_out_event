class_name BoolGridNodeSingleConditionToAction
extends Node

signal on_condition_enter()
signal on_condition_exit()
signal on_condition_state_changed(new_state: bool)
signal on_condition_state_updated(new_state: bool)
signal on_condition_enter_emitted_text(text_image: String)
signal on_condition_exit_emitted_text(text_image: String)

@export var _condition_as_text_image: String
@export var _grid_as_text_image: String
@export var _condition_state:bool = false

@export_group("Emit Text When Condition")
@export var _emit_text_when_condition_enter: Array[String] = []
@export var _emit_text_when_condition_exit: Array[String] = []

func set_condition_as_text_image(new_condition_as_text_image: String) -> void:
	_condition_as_text_image = new_condition_as_text_image
	check_for_condition()

func set_grid_as_text_image(new_grid_as_text_image: String) -> void:
	_grid_as_text_image = new_grid_as_text_image
	check_for_condition()

func check_for_condition():
	if _condition_as_text_image == null or _grid_as_text_image == null:
		return
	if _condition_as_text_image == "":
		return
	if _grid_as_text_image == "":
		return
	
	var is_valid = BoolGridUtility.compare_condition_vs_grid_text_image(_condition_as_text_image, _grid_as_text_image)
	var old_condition_state = _condition_state
	_condition_state = is_valid
	if old_condition_state != _condition_state:	
		if is_valid:
			on_condition_enter.emit()
			for text_image in _emit_text_when_condition_enter:
				if text_image != null and text_image != "":
					on_condition_enter_emitted_text.emit(text_image)
		else:
			on_condition_exit.emit()
			for text_image in _emit_text_when_condition_exit:
				if text_image != null and text_image != "":
					on_condition_exit_emitted_text.emit(text_image)
		on_condition_state_changed.emit(_condition_state)
	on_condition_state_updated.emit(is_valid)
