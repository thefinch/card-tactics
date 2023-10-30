extends Node

class_name Battle

signal end_of_battle

# the combatants involved in the battle
var combatants: Array = []

# the turn order for the current round
var turn_order

# the combatant that is currently taking their turn
var current_combatant: Combatant

# creates a new turn order based on the current combatants
func make_new_turn_order():
	turn_order = combatants.duplicate()

# adds a new combatant to the queue
func add_combatant(new_combatant: Combatant):
	prints('adding combatant to list', new_combatant)
	combatants.append(new_combatant)
	make_new_turn_order()
	
	# when the combatant dies, remove them from the list of combatants
	new_combatant.get_health_manager().dead.connect(remove_combatant)

# if a combatant can't fight anymore, take them out of the turn structure
func remove_combatant(no_longer_fighting: Combatant):
	combatants.erase(no_longer_fighting)
	make_new_turn_order()

# ends the current combatant's turn and queues up the next combatant
func next_turn():
	if turn_order.is_empty():
		make_new_turn_order()
	
	current_combatant = turn_order.pop_front()
	
	return current_combatant

func do_battle():
	while !combatants.is_empty():
		next_turn()
		prints('current combatant taking turn', current_combatant)
		current_combatant.take_turn()
		await current_combatant.turn_finished
		
	end_of_battle.emit()
