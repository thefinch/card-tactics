extends Node3D

class_name Combatant

signal turn_finished

@export var controllable: bool = false

# gets the health manager
func get_health_manager() -> Health:
	return $Health

# defaults to a random action in the list
func select_action() -> Action:
	var action
	var actions = $Actions.get_children()
	if controllable:
		action = select_from_menu(actions)
	else:
		action = actions.pick_random()
		
	return action

func select_from_menu(actions: Array) -> Action:
	# show a menu with the actions listed
	var selected_action
	for action in actions:
		var label = action.get_label()
		print('label for action', label)
		
	return selected_action

# picks an action and executes it
func take_turn():
	var action = select_action()
	if action: 
		action.execute()
		await action.finished
		
	turn_finished.emit()
