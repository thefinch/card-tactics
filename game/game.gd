extends Node3D

# the thing that manages the camera for us
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
	load_actors()
	
	# initialize the state machine
	state_machine.init(self)

func load_level() -> void:
	# load up the map
	var level = preload("res://levels/level/level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

func load_actors() -> void:
	# load up the characters
	var elena_scene = "res://actors/elena/elena.tscn"
	var elena = load_actor(elena_scene)
	
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
func load_actor(actor):
	# load the actor
	var loaded = load(actor).instantiate()
	var scene_name = loaded.scene_file_path.get_file().replace('.tscn', '')
	loaded.name = scene_name
	
	# give the actor access to the UI
	loaded.get_combatant().set_ui(ui)
	
	# add the actor to the scene
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
	
	# place the active indicator around the active character
	if state_machine.current_state is BattleState:
		ui.set_active_indicator_size(2)
		ui.place_active_indicator(active_character.position + Vector3(0, 1, 0))
