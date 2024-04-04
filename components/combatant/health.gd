extends ProgressBar

class_name Health

# signal sent when this is dead
signal dead

# sets the max health this can have
func set_max_health(new_max_health):
	max_value = new_max_health

# sets the current health
func set_current_health(new_current_health):
	value = new_current_health
	prints('current health:',  value)

# gets the current health
func get_health():
	return value

# gets the max health
func get_max_health():
	return max_value

# decreases current health by given amount of damage
func deal_damage(damage: int):
	prints('dealing damage', damage)
	# deal the damage
	value -= damage
	
	# max sure we never go negative
	if value <= 0:
		value = 0
		
	# check if this is dead
	prints('current health', value)
	if value == 0:
		dead.emit()

# increases the current health by the given amount
func heal(health: int):
	prints('healing for', health)
	# heal us up
	value += health
	
	# make sure we can't overheal
	if value > max_value:
		value = max_value
	prints('current health', value)
