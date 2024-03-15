extends Node3D

class_name CameraController

@onready var camera = get_node('SpringArm3D/Camera3D')

var active_target
var zoom_speed = 10
var max_height = 70
var min_height = 30
var height = (max_height + min_height) / 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_target == null:
		return

	# set new y position if needed
	var screen_position_of_target = camera.unproject_position(active_target.global_position)
	var screen = get_viewport().size
	var third = screen.y / 3
	var lower_third = 2 * third
	var new_y = global_position.y
	var y_offset = 1
	if screen_position_of_target.y > lower_third:
		new_y -= y_offset
	elif screen_position_of_target.y < third:
		new_y += y_offset

	# move the camera
	global_position = global_position.lerp(
		Vector3(active_target.global_position.x, new_y, global_position.z),
		delta * zoom_speed
	)
	
	camera.size = height

# initiates a zoom in or out
func zoom(height_change: int):
	height += height_change
	height = clampi(height, min_height, max_height)

func set_active_target(new_active_target):
	active_target = new_active_target
	
# figure out what we clicked on
func get_what_was_clicked():
	# build the ray query
	var ray_length = 1000
	var mouse_position = get_viewport().get_mouse_position()
	var ray_query  = PhysicsRayQueryParameters3D.new()
	ray_query.from = camera.project_ray_origin(mouse_position)
	ray_query.to   = ray_query.from + camera.project_ray_normal(mouse_position) * ray_length
	ray_query.collide_with_areas  = true
	ray_query.collide_with_bodies = true

	# send the ray out into space
	var space = get_world_3d().direct_space_state
	var hit   = space.intersect_ray(ray_query)

	return hit
