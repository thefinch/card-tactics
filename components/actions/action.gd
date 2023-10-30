extends Node

class_name Action

signal finished

# the label for the action
var label: String = 'Wait'

# returns the label for the action
func get_label():
	return label
	
# executes the action
func execute():
	finished.emit()
