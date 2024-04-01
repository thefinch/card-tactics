extends State

class_name IdleState

@export
var walking_state: State

@export
var death_state: State

# run when the state is entered
func enter() -> void:
	parent.change_animation('Idle')

# change the state if needed
func process_frame(_delta: float) -> State:
	# stop doing anything if this is dead
	if parent.is_dead():
		return death_state
		
	# if we have a new destination, change to the walking state
	if not parent.nav_agent.is_navigation_finished():
		return walking_state

	return null
