class_name Character

extends CharacterBody3D

@onready
var animation_player: AnimationPlayer = $Model/AnimationPlayer

@onready
var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready
var state_machine: StateMachine = $StateMachine

@onready
var combatant: Combatant = $Combatant

# Called when the node enters the scene tree for the first time.
func _ready():
	# make sure the animations are setup
	for label in animation_player.get_animation_list():
		var anim = animation_player.get_animation(label)
		anim.loop_mode = Animation.LOOP_LINEAR
	
	# add all actions to the combatant
	for action in $Actions.get_children():
		combatant.add_action(action)
	
	# setup the state machine
	state_machine.init(self)

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

# gets the combantant for this character
func get_combatant():
	return $Combatant

# let the state machine handle things
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

# let the state machine handle things
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

# let the state machine handle things
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
