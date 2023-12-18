extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var combatant_name = scene_file_path.get_file().replace('.tscn', '')
	combatant_name = 'combatant:' + combatant_name + ':' + str(get_instance_id())
	$Combatant.name = combatant_name
