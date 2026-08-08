
class_name BoolGridUtility
extends Node


static func compare_condition_vs_grid_text_image(condition:String, grid:String) -> bool:
	if condition == null or grid == null:
		return false
	if condition == "" or grid == "":
		return false
	condition = condition.strip_edges()
	grid = grid.strip_edges()

	var condition_lines = condition.split("\n", false)
	var grid_lines = grid.split("\n", false)

	if condition_lines.size() != grid_lines.size():
		return false

	## compare each char.
	## 1 but 1
	## 0 must be 0
	## - can be anything
	var y_t_d :int=0
	for condition_line in condition_lines:
		condition_line = condition_line.strip_edges()
		var grid_line = grid_lines[y_t_d].strip_edges()
		if condition_line.length() != grid_line.length():
			return false
		var x_l_r :int=0
		for condition_char in condition_line:
			var grid_char = grid_line[x_l_r]
			if condition_char == "1":
				if grid_char != "1":
					return false
			elif condition_char == "0":
				if grid_char != "0":
					return false
			x_l_r += 1
		y_t_d += 1
	return true


static func get_width_height_of_text_image(text_image:String) -> Vector2i:
	var lines = text_image.split("\n", false)
	var width:int=0
	var height:int=0
	for line in lines:
		line = line.strip_edges()
		if line.length() > width:
			width = line.length()
		height += 1
	return Vector2i(width, height)
