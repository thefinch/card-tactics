extends Node3D

@onready var camera = get_node('SpringArm3D/Camera3D')

var camera_should_be
var zoom_speed = 10
var active_character
var height = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if camera_should_be != null \
#		and camera.global_position != camera_should_be:
#		camera.global_position = camera.global_position.lerp(camera_should_be, delta * zoom_speed)
	if active_character != null:
		global_position = active_character.global_position + Vector3(0, height, 0)
		camera.look_at(active_character.get_look_at().global_position)

# initiates a zoom in or out
func zoom(height_change: int):
	height += height_change
	if height > 30:
		height = 30
	if height < 1:
		height = 1

func set_active_character(new_active_character):
	active_character = new_active_character
	
# figure out what we clicked on
func get_what_was_clicked():
	# find out what we clicked on
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 100
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = camera.project_ray_origin(mouse_position)
	ray_query.to = ray_query.from + camera.project_ray_normal(mouse_position) * ray_length
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	
	return space.intersect_ray(ray_query)
