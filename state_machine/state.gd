extends Node

class_name State

# hold a reference to the thing that uses this state
var parent

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:	
	return null
	
func process_physics(delta: float) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
