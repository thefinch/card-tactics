extends Node3D

@onready var camera = get_node('CameraController')

# Called when the node enters the scene tree for the first time.
func _ready():
	# load up the map
	var level = preload("res://levels/level/Level.tscn").instantiate()
	$Map.add_child(level)
	level.global_rotate(Vector3(0, 1, 0), -45)

	# load up the characters
	var elena_scene = "res://characters/elena/Elena.tscn"
	var elena = load_character(elena_scene)
	
	# let the manager know what it needs to know
	Manager.set_camera(camera)
	Manager.set_active_character(elena)

	Manager.begin_battle()

# load up the characters
func load_character(character):
	# load the character
	var loaded = load(character).instantiate()
	var scene_name = loaded.scene_file_path.get_file().replace('.tscn', '')
	loaded.name = scene_name
	
	# populate the actions for the combatant
	var combatant = loaded.get_combatant()
	combatant.name = 'combatant:' + scene_name
	var attack = Attack.new()
	combatant.add_action(attack)
	
	# add the character to the scene
	$Team.add_child(loaded)
	var char_scale = 3
	loaded.global_scale(Vector3(char_scale, char_scale, char_scale))
	
	return loaded
