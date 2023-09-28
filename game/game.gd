extends Node3D

var active_character: Character
var camera_should_be
var camera
var zoom_speed = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	# load up the map
	var level = preload("res://levels/level/level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

	# load up the characters
	var elena = preload("res://characters/elena/elena.tscn").instantiate()
	$Team.add_child(elena)
	var char_scale = 3
	elena.global_scale(Vector3(char_scale, char_scale, char_scale))
	active_character = elena
	
	# keep track of the camera
	camera = $Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera_should_be != null \
		and camera.global_position != camera_should_be:
		camera.global_position = camera.global_position.lerp(camera_should_be, delta * zoom_speed)

# figure out what we clicked on
func get_what_was_clicked():
	# find out what we clicked on
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 100
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = camera.project_ray_origin(mouse_position)
	ray_query.to = ray_query.from + camera.project_ray_normal(mouse_position) * ray_length
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	
	return space.intersect_ray(ray_query)

# get what we clicked on a decide what do do with it
func handle_click():
	var result = get_what_was_clicked()
	if result:
		# see if we clicked somewhere we should be able to walk to
		if result.collider.get_class() == 'StaticBody3D':
			# set the position the agent should move to
			active_character.set_target_position(result.position)
		else:
			print('clicked on', result)

# initiates a zoom in or out
func zoom(zoom_vector : Vector3):
	camera_should_be = camera.global_position + zoom_vector

func _input(event):
	# check if we're clicking on something
	var clicked = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_released()
	if clicked:
		handle_click()
		
	# check if we're zooming in
	var zoom_in = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_UP \
		and event.is_released()
	if zoom_in:
		zoom(Vector3(0, -1, -1))
		
	# check if we're zooming out
	var zoom_out = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_DOWN \
		and event.is_released()
	if zoom_out:
		zoom(Vector3(0, 1, 1))
