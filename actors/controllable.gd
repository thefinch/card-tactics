extends Combatant

class_name ControllableCombatant

# a reference to the UI
var ui

# this looks stupid but it makes things work
func _ready():
	super._ready()

# sets the UI manager so we can request action info from it
func set_ui(new_ui):
	ui = new_ui

# selects which combatant we want to target
func select_target(action: Action):
	# @TODO open up the UI to select a combatant
	prints('selecting a target for action', action.get_label())
	# get the combatants and remove yourself from the list
	var combatants = battle_state.get_combatants()
	
	# !! for testing we don't want to select ourself !!
	combatants.erase(self)
	var target = combatants.pick_random()
	prints('selected target', target.get_nice_name())
	# !! @TODO in the future, we want to highlight options and require a click to select !!

	return target
	
func select_target_position():
	# select the target from the UI
	ui.select_target_position(get_parent(), self.max_distance)
	var selected_target = await ui.target_position_selected 
	prints('selected target position', selected_target)
	return selected_target

func execute_selected_action(id):
	print('hiding the menu')
	var action = ui.get_selected_action(id)
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
	ui.populate_action_menu(self.actions, execute_selected_action)
