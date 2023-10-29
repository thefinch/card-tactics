extends "../action.gd"

class_name Attack

@export var damage : int = 1
var target : Combatant

# Called when the node enters the scene tree for the first time.
func _ready():
	label = 'Attack'

func set_target(new_target : Combatant):
	target = new_target

func execute():
	target.get_health_manager().deal_damage(damage)
