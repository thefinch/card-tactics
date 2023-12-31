extends InputState

# the state that manages exploration
@export
var adventure_state: State

# the combatants involved in the battle
var combatants: Array = []

# the turn order for the current round
var turn_order

# the combatant that is currently taking their turn
var current_combatant: Combatant

# run when the state is entered
func enter() -> void:
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
			parent.get_camera().set_active_target(combatant)
		)
		if !combatant.is_in_group('controllable'):
			add_combatant(combatant)
	
	# commence the fighting
	next_turn()

# wrapper around the parent's _process_input call
func process_input(event: InputEvent):
	# check for any zooming
	super(event)

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
		prints('removing combatant because it died', new_combatant)
		remove_combatant(new_combatant)
	)
	
	# making the combatant start the next turn when theirs is done
	new_combatant.turn_finished.connect(func():
		# wait before the next turn starts
		prints('waiting for the next turn to start')
		await get_tree().create_timer(3.0).timeout
		prints('starting the next turn')
		
		# take the next turn
		next_turn()
	)
	
	prints('adding combatant to list', new_combatant.name)
	combatants.append(new_combatant)
	make_new_turn_order()

# if a combatant can't fight anymore, take them out of the turn structure
func remove_combatant(no_longer_fighting: Combatant):
	combatants.erase(no_longer_fighting)
	turn_order.erase(no_longer_fighting)

# ends the current combatant's turn and queues up the next combatant
func next_turn():
	prints('\ntaking next turn\n')
	
	# break out if needed
	if not any_controllable_characters_left() \
		or combatants.size() < 2:
		return

	# make a new turn order if everyone has taken their turn
	if turn_order.is_empty():
		make_new_turn_order()
	
	# make the next combatant take their turn
	current_combatant = turn_order.pop_front()
	prints('current combatant taking turn', current_combatant)
	current_combatant.take_turn()

# check if there are any controllable combatants left
func any_controllable_characters_left() -> bool:
	for combatant in combatants:
		if combatant is ControllableCombatant:
			return true
	
	return false

func process_frame(delta):
	# end game when there are no controllable characters
	if not any_controllable_characters_left():
		prints('game is over')
		return adventure_state
	
	# end combat when no one is around to fight
	if combatants.size() < 2:
		prints('battle is over')
		return adventure_state
