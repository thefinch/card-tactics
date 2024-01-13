extends Combatant

class_name ControllableCombatant

# 
var menu: PopupMenu

# this looks stupid but it makes things work
func _ready():
	pass

# selects which combatant we want to target
func select_target(action: Action):
	# @TODO open up the UI to select a combatant
	prints('selecting a target for action', action.get_label())
	# get the combatants and remove yourself from the list
	var combatants = battle_state.get_combatants()
	
	# !! for testing we don't want to select ourself !!
	combatants.erase(self)
	var target = combatants.pick_random()
	prints('selected target', target)
	# !! @TODO in the future, we want to highlight options and require a click to select !!

	return target
	
func select_target_position():
	# select the target from the UI
	UI.select_target_position(self.max_distance)
	var selected_target = await UI.target_position_selected 
	prints('selected target position', selected_target)

func execute_selected_action(id):
	print('hiding the menu')
	menu.hide()
	menu.disconnect('id_pressed', execute_selected_action)
	
	# get the selected action from the popup menu
	var index = menu.get_item_index(id)
	var selected_action_label = menu.get_item_text(index)
	
	# find the action and execute it
	prints('actions might be empty?', self.actions)
	for action in self.actions:
		prints('selected action: ', action.get_label())
		if action.get_label() == selected_action_label:
			prints('preparing the selected action', action.get_label())
			action.prepare()

# picks an action and executes it
func take_turn():
	# call the callback if necessary
	if pre_turn_callback:
		await pre_turn_callback.call()
		
	# end the turn if there's nothing to do
	if self.actions.size() == 0:
		prints('no actions so this turn is over')
		turn_finished.emit()
		return
	
	# select an action with the UI
	prints('selecting action from the menu')
	UI.populate_action_menu(self.actions)
	menu = UI.get_action_menu()
	menu.connect('id_pressed', execute_selected_action)
	
	# show the menu
	menu.show()
	prints('showing the menu',menu)
	
	await menu.id_pressed
