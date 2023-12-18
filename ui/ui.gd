extends Node2D

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
