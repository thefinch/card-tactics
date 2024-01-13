extends InputState

class_name AdventureState

# the state that manages battles
@export
var battle_state: State

# bool that turns true when the active character enters a battle start area
var ready_for_battle: bool = false

func enter() -> void:
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
	
	# see if we need to click around and move anywhere
	var clicked = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_released()
	if clicked:
		var hit = parent.get_camera().get_what_was_clicked()
		if hit:
			parent.get_active_character().set_target_position(hit.position)
			parent.place_destination_area_indicator(hit.position, hit.normal)

func process_frame(_delta: float) -> State:
	# place the movement ring around the active character
	parent.set_area_indicator_size(3)
	parent.place_move_area_indicator(parent.get_active_character().position + Vector3(0, 0.2, 0))
	
	# hide the area indicator when they're done walking
	if parent.get_active_character().nav_agent.is_navigation_finished():
		parent.hide_destination_area_indicator()
	
	# switch to battle if we walked into a battle start area
	if ready_for_battle:
		# make sure we don't go back into battle
		# when we come back into adventure mode
		ready_for_battle = false
		
		# stop the character from moving
		var active = parent.get_active_character()
		active.set_target_position(active.position)
		
		return battle_state
		
	return null
