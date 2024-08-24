extends InputState

class_name AdventureState

# the state that manages battles
@export
var battle_state: State

# bool that turns true when the active character enters a battle start area
var ready_for_battle: bool = false

# bool that allows continuous updating of the next position for the player
var allow_continuous: bool = false

func enter() -> void:
	# make sure the indicators are hidden
	parent.ui.hide_move_area_indicator()
	parent.ui.hide_destination_area_indicator()
	parent.ui.hide_active_indicator()
	
	# make sure health bars are hidden
	get_tree().call_group('combatant', 'hide_health_bar')
	
	# make sure all battle start areas start battle appropriately
	var all_battle_starters = get_tree().get_nodes_in_group('battle_starter')
	for starter:Area3D in all_battle_starters:
		starter.body_entered.connect(func(body):
			# flip the flag to send us into battle
			if body == parent.get_active_character():
				ready_for_battle = true
			
			# stop this from triggering a battle again
			starter.visible = false
		)

func process_input(event: InputEvent):
	# check for any zooming
	super(event)
	
	# see if we are using our directional buttons
	var direction_pressed = Input.is_action_pressed('ui_left') \
		or Input.is_action_pressed('ui_right') \
		or Input.is_action_pressed('ui_up') \
		or Input.is_action_pressed('ui_down')
	var current_position = parent.get_active_character().position
	if direction_pressed:
		# figure out the new position
		var new_position = current_position
		var movement_amount = 3
		if Input.is_action_pressed('ui_left'):
			new_position += Vector3(-movement_amount, 0, 0)
		if Input.is_action_pressed('ui_right'):
			new_position += Vector3(movement_amount, 0, 0)
		if Input.is_action_pressed('ui_up'):
			new_position += Vector3(0, 0, -movement_amount)
		if Input.is_action_pressed('ui_down'):
			new_position += Vector3(0, 0, movement_amount)
		
		# set the new position
		prints('setting new position', new_position)
		parent.get_active_character().set_target_position(new_position)
	
	# see if we need to click around and move anywhere
	var start_click = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed()
	if start_click:
		allow_continuous = true
	
	# see if we need to end continuous position updates
	var end_click = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_released()
	if end_click:
		allow_continuous = false
	
	# if we're aiming to move somewhere, figure out where and try to go there
	var clicked = end_click or allow_continuous
	if clicked:
		var hit = parent.get_camera().get_what_was_clicked()
		if hit:
			parent.get_active_character().set_target_position(hit.position)
			parent.ui.place_destination_area_indicator(hit.position, hit.normal)

func process_frame(_delta: float) -> State:
	# hide the area indicator when they're done walking
	if parent.get_active_character().nav_agent.is_navigation_finished():
		parent.ui.hide_destination_area_indicator()
	
	# switch to battle if we walked into a battle start area
	if ready_for_battle:
		# make sure we don't go back into battle
		# when we come back into adventure mode
		ready_for_battle = false
		
		# stop the character from moving
		var active = parent.get_active_character()
		active.set_target_position(active.position)
		parent.ui.hide_destination_area_indicator()
		
		return battle_state
		
	return null
