class_name BoolGridBinaryStateResource
extends Resource


signal on_cell_changed_state_index_1d(cell_index: int, new_value: bool)
signal on_cell_changed_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool)
signal on_cell_updated_state_index_1d(cell_index: int, new_value: bool)
signal on_cell_updated_state_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool)
signal on_grid_updated_state_from_group_set()

@export var _grid_width: int=4
@export var _grid_height: int=4
@export_group("Grid Value")
@export var _grid_values: Array = []
@export_group("Grid Debug")
@export var _grid_cell_count: int=16

func _check_resize():
	if _grid_values.size() != _grid_width * _grid_height:
		_grid_values.resize(_grid_width * _grid_height)
		_grid_cell_count = _grid_width * _grid_height

func set_cell_with_index_1d(cell_index: int, new_value: bool) -> void:
	
	_check_resize()
	if cell_index < 0 or cell_index >= _grid_values.size():
		return
	var old_value = _grid_values[cell_index]
	_grid_values[cell_index] = new_value

	on_cell_updated_state_index_1d.emit(cell_index, new_value)
	on_cell_updated_state_index_2d.emit(cell_index % _grid_width, cell_index / _grid_width, new_value)
	if old_value != new_value:
		on_cell_changed_state_index_1d.emit(cell_index, new_value)
		on_cell_changed_state_index_2d.emit(cell_index % _grid_width, cell_index / _grid_width, new_value)

func set_cell_with_index_2d(cell_x_left_right: int, cell_y_top_down: int, new_value: bool) -> void:
	_check_resize()
	if cell_x_left_right < 0 or cell_x_left_right >= _grid_width:
		return
	if cell_y_top_down < 0 or cell_y_top_down >= _grid_height:
		return
	var cell_index = cell_y_top_down * _grid_width + cell_x_left_right
	set_cell_with_index_1d(cell_index, new_value)

func get_cell_with_index_1d(cell_index: int) -> bool:
	_check_resize()
	if cell_index < 0 or cell_index >= _grid_values.size():
		return false
	return _grid_values[cell_index]

func get_cell_with_index_2d(cell_x_left_right: int, cell_y_top_down: int) -> bool:
	_check_resize()
	if cell_x_left_right < 0 or cell_x_left_right >= _grid_width:
		return false
	if cell_y_top_down < 0 or cell_y_top_down >= _grid_height:
		return false
	var cell_index = cell_y_top_down * _grid_width + cell_x_left_right
	return get_cell_with_index_1d(cell_index)

func get_grid_width() -> int:
	return _grid_width

func get_grid_height() -> int:
	return _grid_height


func reset_to_zero() -> void:
	_check_resize()
	for i in range(_grid_values.size()):
		set_cell_with_index_1d(i, false)
	on_grid_updated_state_from_group_set.emit()

func set_with_text_image(text_image: String) -> void:
	var lines = text_image.split("\n", false)
	var x_l_r :int=0
	var y_t_d :int=0
	var width:int=0
	var height:int=0

	for line in lines:
		line = line.strip_edges()
		if line.length() > width:
			width = line.length()
		height += 1
	_grid_width = width
	_grid_height = height
	_check_resize()

	for line in lines:
		line = line.strip_edges()
		x_l_r = 0
		for char in line:
			if char == "1":
				set_cell_with_index_2d(x_l_r, y_t_d, true)
			elif char == "0":
				set_cell_with_index_2d(x_l_r, y_t_d, false)
			x_l_r += 1
		y_t_d += 1
	
	on_grid_updated_state_from_group_set.emit()
	

func is_in_text_image_context(text_image: String):
	# state
	#11000
	#10000
	#condition example
	#11--0
	#1---0
	# 1 must be true  
	# 0 must be false
	# - can be anything

	var lines = text_image.split("\n", false)
	var x_l_r :int=0
	var y_t_d :int=0
	for line in lines:
		line = line.strip_edges()
		x_l_r = 0
		if y_t_d >= _grid_height:
			return false
		for char in line:
			if x_l_r >= _grid_width:
				return false
			if char == "1":
				if not get_cell_with_index_2d(x_l_r, y_t_d):
					return false
			elif char == "0":
				if get_cell_with_index_2d(x_l_r, y_t_d):
					return false
			x_l_r += 1
		y_t_d += 1
	return true


func get_text_image() -> String:
	var text_image: String = ""
	for y_t_d in range(_grid_height):
		for x_l_r in range(_grid_width):
			if get_cell_with_index_2d(x_l_r, y_t_d):
				text_image += "1"
			else:
				text_image += "0"
		text_image += "\n"
	return text_image


func set_with_bool_array_as_copy(array: Array[bool]) -> void:
	_check_resize()
	for i in range(min(array.size(), _grid_values.size())):
		set_cell_with_index_1d(i, array[i])
	on_grid_updated_state_from_group_set.emit()

func get_as_bool_array_duplicate() -> Array[bool]:
	_check_resize()
	return _grid_values.duplicate()

func get_as_bool_array_reference() -> Array[bool]:
	_check_resize()
	return _grid_values

 
