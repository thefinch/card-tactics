extends Node3D

@onready var player = get_node('AnimationPlayer')

enum states {IDLE, WALK}
var state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	# make sure the animations are setup
	var anim : Animation = player.get_animation('Idle')
	anim.loop_mode = Animation.LOOP_LINEAR
	anim = player.get_animation('Walk')
	anim.loop_mode = Animation.LOOP_LINEAR
	
	# start the idle animation
	change_animation('Idle')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# switches to the provided animation
func change_animation(label):
	var map = {
		'Idle': 'Armature',
		'Walk': 'Armature_001'
	}
	for key in map:
		get_node(map[key]).visible = false
	get_node(map[label]).visible = true
	player.play(label)

func _input(event):
	# figure out which state we need to be in
	var direction
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_W:
					state = states.WALK
					direction = Vector3(0, global_position.y, 1)
				KEY_A:
					state = states.WALK
					direction = Vector3(1, global_position.y, 0)
				KEY_S:
					state = states.WALK
					direction = Vector3(0, global_position.y, -1)
				KEY_D:
					state = states.WALK
					direction = Vector3(-1, global_position.y, 0)
				_:
					state = states.IDLE
		elif event.is_released():
			state = states.IDLE
		
	# change the state if needed
	var state_animations = {
		states.IDLE: 'Idle',
		states.WALK: 'Walk'
	}
	if player.get_current_animation() != state_animations[state]:
		change_animation(state_animations[state])
		
	if direction:
		look_at(direction)
