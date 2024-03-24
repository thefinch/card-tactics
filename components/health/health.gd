extends Node3D

class_name Health

# the max health of this thing
@export var max_health: int = 1

# the current health of this thing
var current_health: int

# signal sent when this is dead
signal dead

# signal sent when this is damaged
signal damaged

# signal sent when this is healed
signal healed

# Called when the node enters the scene tree for the first time.
func _ready():
	set_current_health(max_health)

func set_max_health(new_max_health):
	max_health = new_max_health
	
func set_current_health(new_current_health):
	current_health = new_current_health

# gets the current health
func get_health():
	return current_health

# decreases current health by given amount of damage
func deal_damage(damage: int):
	prints('dealing damage', damage)
	# deal the damage
	current_health -= damage
	damaged.emit()
	
	# max sure we never go negative
	if current_health <= 0:
		current_health = 0
		
	# check if this is dead
	prints('current health', current_health)
	if current_health == 0:
		dead.emit()

# increases the current health by the given amount
func heal(health: int):
	prints('healing for', health)
	# heal us up
	current_health += health
	healed.emit()
	
	# make sure we can't overheal
	if current_health > max_health:
		current_health = max_health
	prints('current health', current_health)
