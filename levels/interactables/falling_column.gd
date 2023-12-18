extends Node3D

@onready var combatant = $Combatant

# Called when the node enters the scene tree for the first time.
func _ready():
	# set the name so we can easily identify this thing
	var combatant_name = scene_file_path.get_file().replace('.tscn', '')
	combatant_name = 'combatant:' + combatant_name + ':' + str(get_instance_id())
	combatant.name = combatant_name
