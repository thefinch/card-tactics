extends InputState

class_name BattleState

# the state that manages exploration
@export
var adventure_state: State

# the combatants involved in the battle
var combatants: Array = []

# the turn order for the current round
var turn_order

# the combatant that is currently taking their turn
var current_combatant: Combatant

# keep track of whether or not we're in a battle
var battle_started: bool = false

# start battle when we enter this state if it hasn't already been started
func enter() -> void:
	if not battle_started:
		begin_battle()

# cleanup everything after the battle ends
func exit() -> void:
	# heal all controllable combatants
	var all_combatants = get_tree().get_nodes_in_group('combatant')
	for combatant in all_combatants:
		if combatant.is_in_group('controllable'):
			var manager = combatant.get_health_manager()
			var max_health = manager.get_max_health()
			manager.set_current_health(max_health)

# creates a turn order and starts the first turn
func begin_battle() -> void:
	# make sure we don't restart the battle when we come back into this state
	battle_started = true
	
	# create a new battle manager
	reset_combatants()
	
	# add all the controllable combatants
	var all_combatants = get_tree().get_nodes_in_group('combatant')
	for combatant in all_combatants:
		if combatant.is_in_group('controllable'):
			add_combatant(combatant)
	
	# add all the enemy combatants
	for combatant in all_combatants:
		combatant.set_pre_turn_callback(func():
			print('running pre-turn callback')
			parent.set_active_character(combatant.get_parent())
		)
		if !combatant.is_in_group('controllable'):
			add_combatant(combatant)
	
	# commence the fighting
	next_turn()

# gets the list of combatants
func get_combatants():
	return combatants.duplicate()

# removes all combatants from this battle
func reset_combatants():
	combatants = []

# creates a new turn order based on the current combatants
func make_new_turn_order():
	turn_order = combatants.duplicate()
	print('new turn order', turn_order)

# adds a new combatant to the queue
func add_combatant(new_combatant: Combatant):
	# give the combatant a way to get info about the battle
	new_combatant.set_battle_state(self)
	
	# make the combatant remove themself from the turn order when they die
	new_combatant.get_health_manager().dead.connect(func():
		prints('removing combatant because it died', new_combatant.get_nice_name())
		remove_combatant(new_combatant)
	)
	
	# making the combatant start the next turn when theirs is done
	new_combatant.turn_finished.connect(func():
		# break out if needed
		if not any_controllable_characters_left() \
			or combatants.size() < 2:
			battle_started = false
			return
		
		# wait before the next turn starts
		await get_tree().create_timer(3.0).timeout
		
		# take the next turn
		next_turn()
	)
	
	combatants.append(new_combatant)
	make_new_turn_order()

# if a combatant can't fight anymore, take them out of the turn structure
func remove_combatant(no_longer_fighting: Combatant):
	combatants.erase(no_longer_fighting)
	turn_order.erase(no_longer_fighting)

# ends the current combatant's turn and queues up the next combatant
func next_turn():
	prints('\ntaking next turn\n')
	
	# make a new turn order if everyone has taken their turn
	if turn_order.is_empty():
		make_new_turn_order()
	
	# make the next combatant take their turn
	current_combatant = turn_order.pop_front()
	prints('current combatant taking turn', current_combatant.get_nice_name())
	current_combatant.take_turn()

# check if there are any controllable combatants left
func any_controllable_characters_left() -> bool:
	for combatant in combatants:
		if combatant is ControllableCombatant:
			return true
	
	return false

# wrapper around the parent's _process_input call
func process_input(event: InputEvent):
	# check for any zooming
	super(event)

# wrapper around the parent's process_frame call
func process_frame(_delta: float) -> State:
	# end game when there are no controllable characters
	if not any_controllable_characters_left():
		prints('game is over')
		parent.get_ui().show_game_over()
		return adventure_state
	
	# end combat when no one is around to fight
	if combatants.size() < 2:
		prints('battle is over')
		parent.get_ui().show_battle_over()
		return adventure_state

	return null
