extends Node3D

@onready var camera = get_node('CameraController')

var active_character: Character
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
	set_active_character(elena)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# sets the active character
func set_active_character(new_active: Character):
	active_character = new_active
	camera.set_active_character(active_character)

# get what we clicked on a decide what do do with it
func handle_click():
	var result = camera.get_what_was_clicked()
	if result:
		# see if we clicked somewhere we should be able to walk to
		if result.collider.get_class() == 'StaticBody3D':
			# set the position the agent should move to
			active_character.set_target_position(result.position)
		else:
			print('clicked on', result)

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
		camera.zoom(-1)
		
	# check if we're zooming out
	var zoom_out = event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_DOWN \
		and event.is_released()
	if zoom_out:
		camera.zoom(1)
