extends Node3D

@onready var camera = get_node('CameraController')

# Called when the node enters the scene tree for the first time.
func _ready():
	# load up the map
	var level = preload("res://levels/level/Level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

	# load up the characters
	var elena = preload("res://characters/elena/Elena.tscn").instantiate()
	$Team.add_child(elena)
	var char_scale = 3
	elena.global_scale(Vector3(char_scale, char_scale, char_scale))
	
	# let the manager know what it needs to know
	Manager.set_camera(camera)
	Manager.set_active_character(elena)
