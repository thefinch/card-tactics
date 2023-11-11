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
		prints('selecting action from the menu')
		action = select_from_menu(actions)
	else:
		prints('selecting action randomly')
		action = actions.pick_random()
		
	return action

func select_from_menu(actions: Array) -> Action:
	# show a menu with the actions listed
	var selected_action
	for action in actions:
		var label = action.get_label()
		prints('label for action', label)
		
	return selected_action

# picks an action and executes it
func take_turn():
	var action = select_action()
	prints('taking action', action)
	if action: 
		action.execute()
		await action.finished
		
	turn_finished.emit()

# adds an action that this combatant can choose on its turn
func add_action(new_action: Action):
	$Actions.add_child(new_action)
