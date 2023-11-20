extends Node2D

@onready var action_menu: PopupMenu = $HUD/Actions

func populate_action_menu(actions: Array):
	# clear out any previous actions
	action_menu.clear()
	
	# list out all the possible actions
	var selected_action
	for action in actions:
		var label = action.get_label()
		prints('label for action', label)
		action_menu.add_item(label)
		
	action_menu.show()

func get_action_menu() -> PopupMenu:
	return action_menu
