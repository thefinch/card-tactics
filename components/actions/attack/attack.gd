extends "../action.gd"

class_name Attack

# the damage that the attack will inflict
@export var damage: int = 1

# the target of the attack
var target: Combatant

# Called when the node enters the scene tree for the first time.
func _ready():
	label = 'Attack'

# assigns the target of the attack
func set_target(new_target: Combatant):
	target = new_target

# requests that the supervisor selects a target
func prepare():
	# select the target
	var selected_target = supervisor.select_target(self)
	set_target(selected_target)
	
	# let things know we're ready to attack
	prepared.emit()

# attack the target
func execute():
	# deal the damage
	prints('going to attack this target', target)
	target.get_health_manager().deal_damage(damage)
	
	# reset the target
	target = null
	
	# let things know that we're done here
	finished.emit()
