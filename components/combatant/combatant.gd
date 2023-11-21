extends Node3D

class_name Combatant

signal turn_finished

@export var controllable: bool = false

var menu: PopupMenu

# gets the health manager
func get_health_manager() -> Health:
	return $Health

func execute_selected_action(id):
	var index = menu.get_item_index(id)
	menu.set_item_disabled(index, true)
	var selected_action_label = menu.get_item_text(index)
	
	var actions = $Actions.get_children()
	for action in actions:
		if action.get_label() == selected_action_label:
			# prepare for the action as needed
			# i.e. select a target
			action.prepare()
			await action.prepared
			
			# execute tha action
			action.execute()
			await action.finished
			
			turn_finished.emit()

# picks an action and executes it
func take_turn():
	var actions = $Actions.get_children()
	if controllable:
		prints('selecting action from the menu')
		UI.populate_action_menu(actions)
		menu = UI.get_action_menu()
		menu.connect('id_pressed', execute_selected_action)
		await menu.id_pressed
		menu.disconnect('id_pressed', execute_selected_action)
	else:
		prints('selecting action randomly')
		var action = actions.pick_random()
		action.execute()
		await action.finished

		turn_finished.emit()

# adds an action that this combatant can choose on its turn
func add_action(new_action: Action):
	$Actions.add_child(new_action)
