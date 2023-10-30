class_name Character

extends CharacterBody3D

@onready var animation_player: AnimationPlayer = get_node('Model/AnimationPlayer')
@onready var nav_agent: NavigationAgent3D = get_node('NavigationAgent3D')

var move_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	# make sure the animations are setup
	var anim: Animation = animation_player.get_animation('Idle')
	anim.loop_mode = Animation.LOOP_LINEAR
	anim = animation_player.get_animation('Walk')
	anim.loop_mode = Animation.LOOP_LINEAR
	
	# start the idle animation
	change_animation('Idle')

func _on_velocity_computed(new_velocity):
	velocity = new_velocity
	move_and_slide()

# make changes each frame
func _physics_process(_delta):
	# drop back into idle if we're done moving
	if nav_agent.is_navigation_finished():
		change_animation('Idle')
		return
	
	move_to_point(move_speed)

# moves this character to the given point
func move_to_point(speed):
	# figure out where to go
	change_animation('Walk')
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
	
	# face where we want to go
	var direction = global_position.direction_to(next_path_position)
	face_direction(next_path_position)
	
	# update the velocity
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

# turn around, every now and then I get a little bit lonely
func face_direction(direction):
	var where_to_look = Vector3(direction.x, global_position.y, direction.z)
	if global_position != where_to_look:
		look_at(where_to_look, Vector3.UP)

# switches to the provided animation
func change_animation(label):
	var map = {
		'Idle': 'Armature',
		'Walk': 'Armature_001'
	}
	
	# hide all the other animations
	for key in map:
		get_node('Model/' + map[key]).visible = false
	get_node('Model/' + map[label]).visible = true
	
	# play the animation we want
	animation_player.play(label)

# set the nav agent
func set_target_position(new_position: Vector3):
	nav_agent.target_position = new_position
