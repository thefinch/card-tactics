extends Node3D

class_name Combatant

signal turn_finished

@export var controllable: bool = false

var menu: PopupMenu

func _ready():
	# when the combatant dies, remove them from the list of combatants
	get_health_manager().dead.connect(func():
		prints('removing combatant because it died', self)
		Battle.remove_combatant(self)
	)

# gets the health manager
func get_health_manager() -> Health:
	return $Health

func select_target(action: Action):
	prints('selecting a target for action', action.get_label())
	# get the combatants and remove yourself from the list
	var combatants = Battle.get_combatants()
	
	# !! for testing we don't want to select ourself !!
	combatants.erase(self)
	var target = combatants.pick_random()
	prints('selected target', target)
	# !! in the future, we want to highlight options and require a click to select !!

	return target

func execute_selected_action(id):
	menu.disconnect('id_pressed', execute_selected_action)
	
	# get the selected action from the popup menu
	var index = menu.get_item_index(id)
	menu.set_item_disabled(index, true)
	var selected_action_label = menu.get_item_text(index)
	
	# find the action and execute it
	var actions = $Actions.get_children()
	prints('actions might be empty?', actions)
	for action in actions:
		if action.get_label() == selected_action_label:
			await execute_action(action)
	prints('done executing the action')

func execute_action(action: Action):
	# when all is said and done, finish the turn
	action.finished.connect(func():
		prints('finishing turn')
		turn_finished.emit()
	)
	
	# when the action is prepared, execute it
	action.prepared.connect(func():
		prints('executing action')
		action.execute()
	)
	
	# prepare the action
	action.prepare()

# picks an action and executes it
func take_turn():
	var actions = $Actions.get_children()
	if actions.size() == 0:
		prints('no actions so this turn is over')
		turn_finished.emit()
		return
	
	if controllable:
		prints('selecting action from the menu')
		UI.populate_action_menu(actions)
		menu = UI.get_action_menu()
		menu.connect('id_pressed', execute_selected_action)
		await menu.id_pressed
	else:
		prints('selecting action randomly')
		var action = actions.pick_random()
		prints('available actions', actions, 'selected action', action)
		execute_action(action)

# adds an action that this combatant can choose on its turn
func add_action(new_action: Action):
	new_action.set_supervisor(self)
	$Actions.add_child(new_action)
