extends InputState

class_name UIState

@export
var battle_state: State

# the menu that shows up when an action needs to be selected
var hud

func _ready():
	hud = load('res://ui/ui.tscn').instantiate()

func select_target_position(max_distance: float) -> void:
	# @TODO need to get input handling here
	# perhaps something that will enable input
	# to be recieved in _input then continue processing?

	# get the position that the player wants to move to
	#var camera = Manager.get_camera()
	#var target_position = camera.get_what_was_clicked()
	#prints('getting what was clicked')
	## let things know that we selected a target
	#target_position_selected.emit(target_position)
	pass
