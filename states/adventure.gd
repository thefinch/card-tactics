extends InputState

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
			if body == parent.get_active_character():
				ready_for_battle = true
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

func process_frame(delta: float) -> State:
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
