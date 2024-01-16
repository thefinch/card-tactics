extends Node3D

# the thing the manages the camera for us
@onready
var camera = $CameraController

# the state manager
@onready
var state_machine = $StateMachine

# the UI that the player will interact with
@onready
var ui = $UI

# the active character
var active_character: Character

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level()
	load_characters()
	
	# initialize the state machine
	state_machine.init(self)

func load_level() -> void:
	# load up the map
	var level = preload("res://levels/level/level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

func load_characters() -> void:
	# load up the characters
	var elena_scene = "res://characters/elena/elena.tscn"
	var elena = load_character(elena_scene)
	
	# let the manager know what it needs to know
	set_active_character(elena)

# gets the gamera manager
func get_camera():
	return camera

# gets the active character
func get_active_character() -> Character:
	return active_character

# sets the active character
func set_active_character(new_active: Character) -> void:
	active_character = new_active
	camera.set_active_target(active_character)

# load up the characters
func load_character(character):
	# load the character
	var loaded = load(character).instantiate()
	var scene_name = loaded.scene_file_path.get_file().replace('.tscn', '')
	loaded.name = scene_name
	
	# give the character access to the UI
	loaded.get_combatant().set_ui(ui)
	
	# add the character to the scene
	$Team.add_child(loaded)
	var char_scale = 3
	loaded.global_scale(Vector3(char_scale, char_scale, char_scale))
	
	return loaded

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
