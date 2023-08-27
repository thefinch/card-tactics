extends CharacterBody3D

@onready var animation_player = get_node('Model/AnimationPlayer')
@onready var nav_agent: NavigationAgent3D = get_node("NavigationAgent3D")

enum states {IDLE, WALK}
var state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	# make sure the animations are setup
	var anim : Animation = animation_player.get_animation('Idle')
	anim.loop_mode = Animation.LOOP_LINEAR
	anim = animation_player.get_animation('Walk')
	anim.loop_mode = Animation.LOOP_LINEAR
	
	# start the idle animation
	change_animation('Idle')

func move_to_point(delta, speed):
	# change the animation if needed
	if animation_player.get_current_animation() != 'Walk':
		change_animation('Walk')

	# figure out where we're going
	var target_position = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(target_position)
	
	# face the direction
	face_direction(target_position)
	
	# move
	velocity = direction * speed
	move_and_slide()
	
func face_direction(direction):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func _process(delta):
	if nav_agent.is_navigation_finished():
		change_animation('Idle')
		return
	
	move_to_point(delta, 3)

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

#func _input(event):
	# figure out which state we need to be in
#	var direction
#	if event is InputEventKey:
#		if event.pressed:
#			match event.keycode:
#				KEY_W:
#					state = states.WALK
#					direction = Vector3(0, global_position.y, 1)
#				KEY_A:
#					state = states.WALK
#					direction = Vector3(1, global_position.y, 0)
#				KEY_S:
#					state = states.WALK
#					direction = Vector3(0, global_position.y, -1)
#				KEY_D:
#					state = states.WALK
#					direction = Vector3(-1, global_position.y, 0)
#				_:
#					state = states.IDLE
#		elif event.is_released():
#			state = states.IDLE
		
	# change the state if needed
#	var state_animations = {
#		states.IDLE: 'Idle',
#		states.WALK: 'Walk'
#	}
#	if animation_player.get_current_animation() != state_animations[state]:
#		change_animation(state_animations[state])
