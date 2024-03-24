extends Node3D

class_name UI

# sent when a movement target is selected
#signal target_position_selected(new_target_position)

# an indicator for where something is going to happen
@onready
var destination_area_indicator = $DestinationAreaIndicator

# an indicator for where the active character can move during their turn
@onready
var move_area_indicator = $MoveAreaIndicator

# an indicator to show which character is active
@onready
var active_indicator = $ActiveIndicator

# the menu that shows up when an action needs to be selected
@onready
var action_menu: PopupMenu = $HUD/Actions

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

func select_target_position(character: Character, max_distance: float) -> void:
	# place the movement ring around the active character
	set_move_area_indicator_size(max_distance)
	place_move_area_indicator(character.position + Vector3(0, 0.2, 0))
	
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

# places an indicator at the given position
func place_destination_area_indicator(new_position: Vector3, normal: Vector3) -> void:
	destination_area_indicator.position = new_position
	destination_area_indicator.rotation = normal
	destination_area_indicator.visible = true
	
# hides the indicator for where the character is moving
func hide_destination_area_indicator():
	destination_area_indicator.visible = false
	
# hides the indicator for where the character can move
func hide_move_area_indicator():
	move_area_indicator.visible = false

# moves the move area indicator to the new position
func place_move_area_indicator(new_position: Vector3) -> void:
	move_area_indicator.position = new_position

# changes the size of the move area indicator
func set_move_area_indicator_size(width: float) -> void:
	move_area_indicator.scale = Vector3(width, width, width)

# hides the indicactor for which character is active
func hide_active_indicator():
	active_indicator.visible = false

# moves the active indicator to the new position
func place_active_indicator(new_position: Vector3) -> void:
	active_indicator.global_position = new_position

# changes the size of the active indicator
func set_active_indicator_size(width: float) -> void:
	active_indicator.scale = Vector3(width, width, width)

# shows the game over screen
func show_game_over():
	var game_over = load("res://ui/game_over/game_over.tscn").instantiate()
	add_child(game_over)

# shows battle over screen
func show_battle_over():
	var battle_over = load("res://ui/battle_over/battle_over.tscn").instantiate()
	add_child(battle_over)
