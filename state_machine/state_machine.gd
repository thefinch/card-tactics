extends Node

class_name StateMachine

# the starting state we're in
@export
var starting_state: State

# the current state we're in
var current_state: State

# give each child the parent to reference as needed
# and enter the inital state
func init(parent) -> void:
	for child in get_children():
		child.parent = parent
		
	change_state(starting_state)

# transition to the provided state
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()

# wrapper around the parent's _process_input call
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

# wrapper around the parent's _process_physics call
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

# wrapper around the parent's _process call
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
