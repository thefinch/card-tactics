extends Node

signal end_of_battle

# the combatants involved in the battle
var combatants: Array = []

# the turn order for the current round
var turn_order

# the combatant that is currently taking their turn
var current_combatant: Combatant

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
	# making the combatant start the next turn when theirs is done
	new_combatant.turn_finished.connect(func():
		# wait before the next turn starts
		prints('waiting for the next turn to start')
		await get_tree().create_timer(1.0).timeout
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
	# end combat when no one is around to fight
	if combatants.size() < 2:
		prints('battle is over')
		end_of_battle.emit()
		return

	# make a new turn order if everyone has taken their turn
	if turn_order.is_empty():
		make_new_turn_order()
	
	# make the next combatant take their turn
	current_combatant = turn_order.pop_front()
	prints('current combatant taking turn', current_combatant)
	current_combatant.take_turn()
