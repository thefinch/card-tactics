extends Node2D

# sent when a movement target is selected
signal target_position_selected(new_target_position)

# the menu that shows up when an action needs to be selected
@onready var action_menu: PopupMenu = $HUD/Actions

func populate_action_menu(actions: Array):
	prints('\npopulating action menu')
	# clear out any previous actions
	action_menu.clear()
	
	# list out all the possible actions
	for action in actions:
		prints('adding action', action)
		var label = action.get_label()
		action_menu.add_item(label)

func get_action_menu() -> PopupMenu:
	prints('action menu', action_menu)
	return action_menu

func select_target_position():
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
