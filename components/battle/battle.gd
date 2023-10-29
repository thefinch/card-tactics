extends Node

var combatants : Array = []
var current_round
var current_combatant : Combatant

# creates a new round
func make_new_round():
	current_round = combatants.duplicate()

# adds a new combatant to the queue
func add_combatant(new_combatant : Combatant):
	combatants.append(new_combatant)
	make_new_round()

# if a combatant can't fight anymore, take them out of the turn structure
func remove_combatant(no_longer_fighting : Combatant):
	combatants.erase(no_longer_fighting)
	make_new_round()

# ends the current combatant's turn and queues up the next combatant
func end_turn():
	if current_round.empty():
		make_new_round()
	
	current_combatant = current_round.pop_front()
	
	return current_combatant
