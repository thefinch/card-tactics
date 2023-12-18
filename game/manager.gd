extends Node3D

var active_character: Character
var camera: CameraController

# manage the modes for the game
enum MODES {ADVENTURE, BATTLE}
var current_mode = MODES.ADVENTURE

# tells the active character where to go
func set_active_character_target_position(selected_position):
	active_character.set_target_position(selected_position)

# sets the active character
func set_active_character(new_active: Character):
	active_character = new_active
	camera.set_active_character(active_character)

# sets which camera is active
func set_camera(new_camera:CameraController):
	camera = new_camera
	
func begin_battle():
	current_mode = MODES.BATTLE
	
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
			camera.set_active_character(combatant)
		)
		if !combatant.is_in_group('controllable'):
			Battle.add_combatant(combatant)
	
	# when the battle is over, shift us back into adventure mode
	Battle.end_of_battle.connect(begin_adventure)
	
	# commence the fighting
	Battle.next_turn()
	
func begin_adventure():
	prints('entering adventure mode')
	current_mode = MODES.ADVENTURE

func _input(event):
	# handle input differently depending on the mode we're in
	match current_mode:
		MODES.ADVENTURE:
			handle_adventure_input(event)
		MODES.BATTLE:
			handle_battle_input(event)
	
	# check if we're zooming in
	var zoom_in = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_UP \
		and event.is_released()
	if zoom_in:
		camera.zoom(-1)

	# check if we're zooming out
	var zoom_out = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_DOWN \
		and event.is_released()
	if zoom_out:
		camera.zoom(1)

func handle_adventure_input(event):
	# handle moving the active character
	var clicked = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_released()
	if clicked:
		var hit = camera.get_what_was_clicked()
		if hit:
			set_active_character_target_position(hit.position)
			
func handle_battle_input(_event):
	pass
