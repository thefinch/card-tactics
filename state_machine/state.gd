extends Node

class_name State

# hold a reference to the thing that uses this state
var parent

# run when the state is entered
func enter() -> void:
	pass
	
# run when the state is exited
func exit() -> void:
	pass

# wrapper around the parent's _process_input call
func process_input(event: InputEvent) -> State:
	return null

# wrapper around the parent's _process_physics call
func process_physics(delta: float) -> State:
	return null

# wrapper around the parent's _process call
func process_frame(delta: float) -> State:
	return null
