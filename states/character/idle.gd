extends State

class_name IdleState

@export
var walking_state: State

# run when the state is entered
func enter() -> void:
	parent.change_animation('Idle')

# if we have a new destination, change to the walking state
func process_frame(_delta: float) -> State:
	if not parent.nav_agent.is_navigation_finished():
		return walking_state

	return null
