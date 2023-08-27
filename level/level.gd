extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_released():
		# find out what we clicked on
		var camera = $Camera3D
		var mouse_position = get_viewport().get_mouse_position()
		var ray_length = 100
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = camera.project_ray_origin(mouse_position)
		ray_query.to = ray_query.from + camera.project_ray_normal(mouse_position) * ray_length
		ray_query.collide_with_areas = true
		ray_query.collide_with_bodies = true
		var result = space.intersect_ray(ray_query)
		
		if result:
			# see if we clicked somewhere we should be able to walk to
			if result.collider.get_class() == 'StaticBody3D':
				# set the position the agent should move to
				var nav_agent = $Team/Elena/NavigationAgent3D
				nav_agent.target_position = result.position
			else:
				print('clicked on', result)