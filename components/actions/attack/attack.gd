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

# deals damage from the attack and resets the target
func execute():
	prints('going to attack this target', target)
	target.get_health_manager().deal_damage(damage)
	
	target = null
	
	finished.emit()
