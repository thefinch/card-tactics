extends Action

class_name Move

# where we want to move
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	label = 'Move'

# assigns the target of the movement
func set_target(new_target: Vector3):
	target = new_target

# requests the supervisor select a target position
func prepare():
	# select the target
	var selected_target = await supervisor.select_target_position()
	#set_target(selected_target)
	
	# let things know that we're prepared to move
	prepared.emit()
	prints('emitted the prepared signal in move action')

# deals damage from the attack and resets the target
func execute():
	# move to the target position
	prints('going to move to this target', target)
	
	# reset the target
	target = null
	
	# let things know we're done here
	finished.emit()
