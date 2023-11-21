extends Node

class_name Action

signal finished
signal prepared

# the label for the action
var label: String = 'Wait'

# the combatant that owns this action
var supervisor: Combatant

# sets the owner for the action
func set_supervisor(new_supervisor: Combatant):
	supervisor = new_supervisor

# returns the label for the action
func get_label():
	return label

# satisfies any requirements for the action before the action is executed
# for example, you may need to select a target before attacking
func prepare():
	prepared.emit()

# executes the action
func execute():
	finished.emit()
