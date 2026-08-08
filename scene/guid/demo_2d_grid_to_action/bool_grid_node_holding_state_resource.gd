class_name BoolGridNodeHoldingStateResource
extends Node


signal on_cell_changed_state_index_1d(cell_index: int, new_value: bool)
signal on_cell_changed_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool)
signal on_cell_updated_state_index_1d(cell_index: int, new_value: bool)
signal on_cell_updated_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool)
signal on_grid_updated_state_from_group_set()

signal on_grid_refresh_debug_as_text_image(text_image: String)



@export var _grid_state_resource: BoolGridBinaryStateResource
@export var _refresh_debug_text_image_on_group_update: bool = true

func _ready() -> void:
		_grid_state_resource.reset_to_zero()
		var r :BoolGridBinaryStateResource = _grid_state_resource
		r.on_cell_changed_state_index_1d.connect(_on_cell_changed_state_index_1d)
		r.on_cell_changed_state_index_2d.connect(_on_cell_changed_state_index_2d)
		r.on_cell_updated_state_index_1d.connect(_on_cell_updated_state_index_1d)
		r.on_cell_updated_state_index_2d.connect(_on_cell_updated_state_index_2d)
		r.on_grid_updated_state_from_group_set.connect(_on_grid_updated_state_from_group_set)
		refresh_debug_text_image()

func _on_cell_changed_state_index_1d(cell_index: int, new_value: bool) -> void:
	on_cell_changed_state_index_1d.emit( cell_index, new_value)

func _on_cell_changed_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool) -> void:
	on_cell_changed_state_index_2d.emit(cell_x_left_right, cell_y_top_down, new_value)

func _on_cell_updated_state_index_1d(cell_index: int, new_value: bool) -> void:
	on_cell_updated_state_index_1d.emit(cell_index, new_value)

func _on_cell_updated_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool) -> void:
	on_cell_updated_state_index_2d.emit(cell_x_left_right, cell_y_top_down, new_value)


func _on_grid_updated_state_from_group_set() -> void:
	if _refresh_debug_text_image_on_group_update:
		refresh_debug_text_image()

func refresh_debug_text_image() -> void:
	var text_image = _grid_state_resource.get_text_image()
	on_grid_refresh_debug_as_text_image.emit(text_image)


func _r() -> BoolGridBinaryStateResource:
	return _grid_state_resource

func set_cell_with_index_1d(cell_index: int, new_value: bool) -> void:
	_r().set_cell_with_index_1d(cell_index, new_value)

func set_cell_with_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool) -> void:
	_r().set_cell_with_index_2d(cell_x_left_right, cell_y_top_down, new_value)
func get_cell_with_index_1d(cell_index: int) -> bool:
	return _r().get_cell_with_index_1d(cell_index)

func get_cell_with_index_2d(cell_x_left_right: int, cell_y_top_down: int) -> bool:
	return _r().get_cell_with_index_2d(cell_x_left_right, cell_y_top_down)

func get_grid_width() -> int:
	return _r().get_grid_width()

func get_grid_height() -> int:
	return _r().get_grid_height()

func reset_to_zero() -> void:
	_r().reset_to_zero()
	refresh_debug_text_image()

func set_with_text_image(text_image: String) -> void:
	_r().set_with_text_image(text_image)
	refresh_debug_text_image()

func is_in_text_image_context(text_image: String) -> bool:
	return _r().is_in_text_image_context(text_image)
	

func get_text_image() -> String:
	return _r().get_text_image()


func set_with_bool_array_as_copy(array: Array[bool]) -> void:
	_r().set_with_bool_array_as_copy(array)
	refresh_debug_text_image()

func get_as_bool_array_duplicate() -> Array[bool]:
	return _r().get_as_bool_array_duplicate()

func get_as_bool_array_reference() -> Array[bool]:
	return _r().get_as_bool_array_reference()

 
