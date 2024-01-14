extends CanvasLayer

class_name UI

# sent when a movement target is selected
#signal target_position_selected(new_target_position)

# the menu that shows up when an action needs to be selected
@onready
var action_menu: PopupMenu = $Actions

var available_actions: Array = []

func get_selected_action(id: int) -> Action:
	# stop showing the menu
	action_menu.hide()
	
	# make sure nothing runs when this thing is done
	for connection in action_menu.id_pressed.get_connections():
		prints(connection)
		action_menu.disconnect('id_pressed', connection.callable)
	
	# get the selected action from the popup menu
	var index = action_menu.get_item_index(id)
	var selected_action_label = action_menu.get_item_text(index)
	
	# find the action and execute it
	prints('actions might be empty?', available_actions)
	for action in available_actions:
		prints('selected action: ', action.get_label())
		if action.get_label() == selected_action_label:
			prints('preparing the selected action', action.get_label())
			return action
			
	return null

func populate_action_menu(actions: Array, call_when_selected: Callable):
	available_actions = actions
	
	prints('\npopulating action menu')
	prints(get_children())
	# clear out any previous actions
	action_menu.clear()
	
	# list out all the possible actions
	for action in available_actions:
		prints('adding action', action)
		var label = action.get_label()
		action_menu.add_item(label)
		
	# set what to do when the thing is clicked
	action_menu.connect('id_pressed', call_when_selected)
	
	# show the menu
	action_menu.show()
	prints('showing the menu', action_menu)
	
	await action_menu.id_pressed
#
#func get_action_menu() -> PopupMenu:
	#prints('action menu', action_menu)
	#return action_menu
#
#func select_target_position(max_distance: float) -> void:
	## @TODO need to get input handling here
	## perhaps something that will enable input
	## to be recieved in _input then continue processing?
#
	## get the position that the player wants to move to
	##var camera = Manager.get_camera()
	##var target_position = camera.get_what_was_clicked()
	##prints('getting what was clicked')
	### let things know that we selected a target
	##target_position_selected.emit(target_position)
	#pass
