extends InputState

func enter() -> void:
	# create a new battle manager
	Battle.reset_combatants()
	
	# add all the controllable combatants
	var combatants = get_tree().get_nodes_in_group('combatant')
	for combatant in combatants:
		if combatant.is_in_group('controllable'):
			Battle.add_combatant(combatant)
	
	# add all the enemy combatants
	for combatant in combatants:
		combatant.set_pre_turn_callback(func():
			print('running pre-turn callback')
			parent.get_camera().set_active_target(combatant)
		)
		if !combatant.is_in_group('controllable'):
			Battle.add_combatant(combatant)
	
	# commence the fighting
	Battle.next_turn()

func process_input(event: InputEvent):
	# check for any zooming
	super(event)
