extends Node3D

# the max health of this thing
@export var max_health : int = 1

# the current health of this thing
var current_health : int

# signal sent with this is dead
signal dead

# signal sent when this is damaged
signal damaged

# signal sent when this is healed
signal healed

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

# gets the current health
func get_health():
	return current_health

# decreases current health by given amount of damage
func deal_damage(damage : int):
	prints('dealing damage', damage)
	# deal the damage
	current_health -= damage
	emit_signal('damaged')
	
	# max sure we never go negative
	if current_health <= 0:
		current_health = 0
		
	# check if this is dead
	if current_health == 0:
		emit_signal('dead')
	prints('current health', current_health)

# increases the current health by the given amount
func heal(health : int):
	prints('healing for', health)
	# heal us up
	current_health += health
	
	# make sure we can't overheal
	if current_health > max_health:
		current_health = max_health
	prints('current health', current_health)
