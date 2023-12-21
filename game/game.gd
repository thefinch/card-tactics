extends Node3D

@onready
var camera = $CameraController

@onready
var state_machine = $InputStateMachine

@onready
var adventure_state = $InputStateMachine/Adventure

var active_character: Character

# Called when the node enters the scene tree for the first time.
func _ready():
	# load up the map
	var level = preload("res://levels/level/Level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

	# load up the characters
	var elena_scene = "res://characters/elena/Elena.tscn"
	var elena = load_character(elena_scene)
	
	# when the battle is over, shift us back into adventure mode
	Battle.end_of_battle.connect(end_battle)
	
	# initialize the state machine
	state_machine.init(self)
	
	# let the manager know what it needs to know
	set_active_character(elena)

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
	
	# populate the actions for the combatant
	var combatant = loaded.get_combatant()
	combatant.name = 'combatant:' + scene_name
	
	# add the attack command
	var attack = Attack.new()
	combatant.add_action(attack)
	
	# add the move command
	var move = Move.new()
	combatant.add_action(move)
	
	# add the character to the scene
	$Team.add_child(loaded)
	var char_scale = 3
	loaded.global_scale(Vector3(char_scale, char_scale, char_scale))
	
	return loaded

func end_battle(controllable_combatants_left):
	# check for game over
	if not controllable_combatants_left:
		prints('game over! show a screen here dummy')
		return
	
	# get back to 'venturin
	state_machine.change_state($InputStateMachine/Adventure)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
