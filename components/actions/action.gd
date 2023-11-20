extends Node

class_name Action

signal finished

# the label for the action
var label: String = 'Wait'

# returns the label for the action
func get_label():
	return label

# satisfies any requirements for the action before the action is executed
# for example, you may need to select a target before attacking
func pre_execute():
	pass

# executes the action
func execute():
	finished.emit()
