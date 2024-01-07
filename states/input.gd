extends State

class_name InputState

func process_input(event: InputEvent):
	# check if we're zooming in
	var zoom_in = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_UP \
		and event.is_released()
	if zoom_in:
		parent.get_camera().zoom(-1)

	# check if we're zooming out
	var zoom_out = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_DOWN \
		and event.is_released()
	if zoom_out:
		parent.get_camera().zoom(1)
