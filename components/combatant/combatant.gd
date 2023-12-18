extends Node3D

class_name Combatant

signal turn_finished

@export var controllable: bool = false

var menu: PopupMenu
var pre_turn_callback

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
	# !! @TODO in the future, we want to highlight options and require a click to select !!

	return target

func execute_selected_action(id):
	print('hiding the menu')
	menu.hide()
	menu.disconnect('id_pressed', execute_selected_action)
	
	# get the selected action from the popup menu
	var index = menu.get_item_index(id)
	var selected_action_label = menu.get_item_text(index)
	
	# find the action and execute it
	var actions = $Actions.get_children()
	prints('actions might be empty?', actions)
	for action in actions:
		prints('selected action: ', action.get_label())
		if action.get_label() == selected_action_label:
			prints('preparing the selected action', action.get_label())
			action.prepare()

func set_pre_turn_callback(callback):
	pre_turn_callback = callback

# picks an action and executes it
func take_turn():
	# call the callback if necessary
	#if pre_turn_callback:
		#await pre_turn_callback.call()
		
	# end the turn if there's nothing to do
	var actions = $Actions.get_children()
	if actions.size() == 0:
		prints('no actions so this turn is over')
		turn_finished.emit()
		return
	
	# select an action
	if controllable:
		prints('selecting action from the menu')
		UI.populate_action_menu(actions)
		menu = UI.get_action_menu()
		menu.connect('id_pressed', execute_selected_action)
		
		# show the menu
		menu.show()
		prints('showing the menu',menu)
		
		await menu.id_pressed
	else:
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
