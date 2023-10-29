extends Node3D

var active_character: Character
var camera: CameraController

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

func _input(event):
	# handle moving the active character
	var clicked = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_released()
	if clicked:
		var hit = camera.get_what_was_clicked()
		if hit:
			set_active_character_target_position(hit.position)
	
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
