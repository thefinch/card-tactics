extends Node3D

class_name Combatant

signal turn_finished

# a function we call before the turn begins
var pre_turn_callback: Callable

# the state that we will interact with to pull info about the battle
var battle_state: State

# sets the battle state that we will interact with
func set_battle_state(new_battle_state: State) -> void:
	battle_state = new_battle_state

# gets the health manager
func get_health_manager() -> Health:
	return $Health

# selects which combatant we want to target
func select_target(action: Action):
	prints('selecting a target for action', action.get_label())
	# get the combatants and remove yourself from the list
	var combatants = battle_state.get_combatants()
	prints('combatants that we can choose from', combatants)
	
	# !! for testing we don't want to select ourself !!
	combatants.erase(self)
	var target = combatants.pick_random()
	prints('selected target', target)
	# !! @TODO in the future, we want to highlight options and require a click to select !!

	return target
	
func select_target_position():
	pass

func set_pre_turn_callback(callback: Callable) -> void:
	pre_turn_callback = callback

# picks an action and executes it
func take_turn():
	# call the callback if necessary
	if pre_turn_callback:
		await pre_turn_callback.call()
		
	# end the turn if there's nothing to do
	var actions = $Actions.get_children()
	if actions.size() == 0:
		prints('no actions so this turn is over')
		turn_finished.emit()
		return
	
	# default to picking a random action
	prints('selecting action randomly')
	var action = actions.pick_random()
	prints('available actions', actions, 'selected action', action)
	prints('preparing the random action', action.get_label())
	action.prepare()

# adds an action that this combatant can choose on its turn
func add_action(new_action: Action):
	# set the supervisor so the action can ask for more info if needed
	new_action.set_supervisor(self)
	
	# when the action is prepared, execute it
	new_action.prepared.connect(func():
		prints('prepared, now executing action')
		new_action.execute()
	)
	
	# when all is said and done, finish the turn
	new_action.finished.connect(func():
		prints('finished with action, now finishing turn')
		turn_finished.emit()
	)
	
	# add to the list of actions that this combatant can choose from
	$Actions.add_child(new_action)
