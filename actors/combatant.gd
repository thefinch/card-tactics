extends Character

class_name Combatant

signal turn_finished

@onready
var health_bar = $Health

# the max distance this action allows movement
@export
var max_distance: int = 3

# the maximum health this can have
@export
var max_health: int = 1

# the actions this combatant can use
var actions: Array

# a function we call before the turn begins
var pre_turn_callback: Callable

# the state that we will interact with to pull info about the battle
var battle_state: State

# get this ready to use
func _ready():
	# do all prep
	super._ready()
	
	# heal up
	max_heal()
	
	# add all actions
	for child in get_children():
		if child is Action:
			add_action(child)
			
	# add this the combatant group
	add_to_group('combatant')

# position the health bar above this thing
func _process(delta:float) -> void:
	super._process(delta)
	health_bar.global_position = global_position + Vector3(0, 7, 0)

# hides the health bar
func hide_health_bar():
	health_bar.visible = false

# shows the health bar
func show_health_bar():
	health_bar.visible = true

# fully heals the combatant
func max_heal():
	var manager = $Health.get_health_manager()
	manager.set_max_health(max_health)
	manager.set_current_health(max_health)

# creates a readable name for us to see during debugging
func get_nice_name():
	var combatant_name = scene_file_path.get_file().replace('.tscn', '')
	combatant_name = 'combatant:' + combatant_name + ':' + str(get_instance_id())
	return combatant_name

# sets the battle state that we will interact with
func set_battle_state(new_battle_state: State) -> void:
	battle_state = new_battle_state

# selects which combatant we want to target
func select_target(action: Action):
	prints('selecting a target for action', action.get_label())
	# get the combatants and remove yourself from the list
	var combatants = battle_state.get_combatants()
	prints('combatants that we can choose from', combatants)
	
	# !! for testing we don't want to select ourself !!
	combatants.erase(self)
	var target = combatants.pick_random()
	prints('selected target', target.get_nice_name(), 'target health', target.get_health_manager().get_health())
	# !! @TODO in the future, we want to highlight options and require a click to select !!

	return target

# selects a target position to move when move action is selected
func select_target_position():
	pass

# sets a function to be called before selecting an action
func set_pre_turn_callback(callback: Callable) -> void:
	pre_turn_callback = callback

# picks an action and executes it
func take_turn():
	# call the callback if necessary
	if pre_turn_callback:
		await pre_turn_callback.call()
		
	# end the turn if there's nothing to do
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
func add_action(new_action: Action) -> void:
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
	actions.append(new_action)
