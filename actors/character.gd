class_name Character

extends Actor

@onready
var animation_player: AnimationPlayer = $Model/AnimationPlayer

@onready
var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready
var combatant: Combatant = $Combatant

func _ready():
	super._ready()
	
	# make sure the animations are setup
	for label in animation_player.get_animation_list():
		var anim = animation_player.get_animation(label)
		anim.loop_mode = Animation.LOOP_LINEAR
	
	# add all actions to the combatant
	for child in combatant.get_children():
		if child is Action:
			combatant.add_action(child)

# switches to the provided animation
func change_animation(label):
	# make sure the one we care about exists
	var map = {
		'Idle': 'Armature',
		'Walk': 'Armature_001'
	}
	if not map.has(label):
		prints('requested animation "' + label + '" and it does not exist in the map')
		return
	var requested = get_node_or_null('Model/' + map[label])
	if not requested:
		prints('requested animation "' + label + '" and it does not exist as an animation')
		return
	
	# hide all the other animations
	for key in map:
		var temp = get_node('Model/' + map[key])
		if temp:
			temp.visible = false
	
	# show the one we care about
	requested.visible = true
	
	# play the animation we want
	animation_player.play(label)

# set the nav agent
func set_target_position(new_position: Vector3):
	nav_agent.target_position = new_position

# gets the combantant for this character
func get_combatant():
	return $Combatant

# checks if this character is dead
func is_dead():
	return $Combatant.get_health_manager().get_health() < 1
