extends InputState

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
