class_name BoolGridKeyValueRegister
extends Node


signal on_grid_cell_changed_state_index_1d(grid_key_name:String, cell_index:int, new_value:bool)
signal on_grid_cell_changed_state_index_2d(grid_key_name:String, cell_x_left_right:int, cell_y_top_down:int, new_value:bool)
signal on_grid_updated(grid_key_name:String, grid_resource:BoolGridBinaryStateResource)
signal on_grid_full_debug_text_report(text_report:String)


@export var _grid_dictionary: Dictionary[String, BoolGridBinaryStateResource] = {}

@export var _add_sinco_at_ready: bool = true
@export var _add_qwerty_at_ready: bool = true

func _ready() -> void:
	if _add_sinco_at_ready:
		create_grid("sinco", 4, 4)
	if _add_qwerty_at_ready:
		create_grid("qwerty", 6, 4)


func refresh_full_log_debug_text_report() -> void:
	var report = get_all_grid_as_debug_text_report()
	on_grid_full_debug_text_report.emit(report)

func create_grid_from_text_image(grid_key_name:String, text_image:String)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	var size = BoolGridUtility.get_width_height_of_text_image(text_image)
	create_grid(grid_key_name, size.x, size.y)


func create_grid(grid_key_name:String, grid_width:int, grid_height:int)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	var new_grid = BoolGridBinaryStateResource.new()
	new_grid._grid_width = grid_width
	new_grid._grid_height = grid_height
	new_grid.reset_to_zero()
	_grid_dictionary[grid_key_name] = new_grid

	new_grid.on_cell_changed_state_index_1d.connect(func(cell_index:int, new_value:bool) -> void:
		on_grid_cell_changed_state_index_1d.emit(grid_key_name, cell_index, new_value)
	)
	new_grid.on_cell_changed_state_index_2d.connect(func(cell_x_left_right:int, cell_y_top_down:int, new_value:bool) -> void:
		on_grid_cell_changed_state_index_2d.emit(grid_key_name, cell_x_left_right, cell_y_top_down, new_value)
	)
	new_grid.on_grid_updated_state_from_group_set.connect(func() -> void:
		on_grid_updated.emit(grid_key_name, new_grid)
	)

func remove_grid(grid_key_name:String)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return
	var grid = _grid_dictionary[grid_key_name]
	# I need to be able to disconnect it butforthat I need class holding theconnection.
	# I don t have the time now
	# TODO: implement disconnecting signals when removing a grid
	# grid.on_cell_changed_state_index_1d.disconnect()
	# grid.on_cell_changed_state_index_2d.disconnect()	
	_grid_dictionary.erase(grid_key_name)

func set_grid_with_text_image(grid_key_name:String, text_image:String)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		create_grid_from_text_image(grid_key_name, text_image)
	var grid = _grid_dictionary[grid_key_name]
	grid.set_with_text_image(text_image)


func _clamp_text_to_upper_strip_edges(text:String)->String:
	if text == null:
		return ""
	text = text.strip_edges().to_upper()
	while text.find("  ") >= 0:
		text = text.replace("  ", " ")
	text= text.replace(" ","_")
	return text.strip_edges().to_upper()

func get_grid_resource_reference(grid_key_name:String)->BoolGridBinaryStateResource:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return null
	return _grid_dictionary[grid_key_name]

func get_grid_as_text_image(grid_key_name:String)->String:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return ""
	var grid = _grid_dictionary[grid_key_name]
	return grid.get_text_image()

func is_grid_key_name_exist(grid_key_name:String)->bool:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	return _grid_dictionary.has(grid_key_name)

func set_or_override_grid_resource_from_key_name(grid_key_name:String, grid_resource:BoolGridBinaryStateResource)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if grid_resource == null:
		return
	_grid_dictionary[grid_key_name] = grid_resource


func is_grid_in_this_condition(grid_key_name:String, condition_text_image:String)->bool:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return false
	var grid = _grid_dictionary[grid_key_name]
	return grid.is_in_text_image_context(condition_text_image)


func set_grid_cell_with_index_1d(grid_key_name:String, cell_index:int, new_value:bool)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return
	var grid = _grid_dictionary[grid_key_name]
	grid.set_cell_with_index_1d(cell_index, new_value)

func set_grid_cell_with_index_2d(grid_key_name:String, cell_x_left_right:int, cell_y_top_down:int, new_value:bool)->void:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return
	var grid = _grid_dictionary[grid_key_name]
	grid.set_cell_with_index_2d(cell_x_left_right, cell_y_top_down, new_value)

func get_grid_cell_with_index_1d(grid_key_name:String, cell_index:int)->bool:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return false
	var grid = _grid_dictionary[grid_key_name]
	return grid.get_cell_with_index_1d(cell_index)	

func get_grid_cell_with_index_2d(grid_key_name:String, cell_x_left_right:int, cell_y_top_down:int)->bool:
	grid_key_name = _clamp_text_to_upper_strip_edges(grid_key_name)
	if not _grid_dictionary.has(grid_key_name):
		return false
	var grid = _grid_dictionary[grid_key_name]
	return grid.get_cell_with_index_2d(cell_x_left_right, cell_y_top_down)


func get_all_grid_as_debug_text_report()->String:
	var result:String=""
	for grid_key_name in _grid_dictionary.keys():
		var grid = _grid_dictionary[grid_key_name]
		result += "Grid Key Name: " + grid_key_name + "\n"
		result += grid.get_text_image() + "\n"
	return result
