extends State

class_name WalkingState

# the state to change to when we're done walking
@export
var idle_state: State

# the speed at which we'll be moving
@export
var move_speed: int

# run when the state is entered
func enter() -> void:
	parent.change_animation('Walk')

# moves this character to the given point
func move_to_point(speed):
	# figure out where to go
	var next_path_position: Vector3 = parent.nav_agent.get_next_path_position()
	var current_agent_position: Vector3 = parent.global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	
	# face where we want to go
	face_direction(next_path_position)
	
	# update the velocity
	if parent.nav_agent.avoidance_enabled:
		parent.nav_agent.set_velocity(new_velocity)
	else:
		parent.velocity = new_velocity
		parent.move_and_slide()

# turn around, every now and then I get a little bit lonely
func face_direction(direction):
	var where_to_look = Vector3(direction.x, parent.global_position.y, direction.z)
	if parent.global_position != where_to_look:
		parent.look_at(where_to_look, Vector3.UP)

# make changes each frame
func process_physics(_delta: float) -> State:
	# drop back into idle if we're done moving
	if parent.nav_agent.is_navigation_finished():
		return idle_state

	# otherwise, we're moving
	move_to_point(move_speed)
	
	return null
