extends CharacterBody3D

@onready var nav: NavigationAgent3D = get_node("NavigationAgent3D")

func _physics_process(delta):
	var marker = get_parent().get_parent().get_node('Marker3D')
	print(marker.global_position, global_position)
	if marker.global_position == global_position:
		return
		
	var direction = Vector3()
	nav.target_position = marker.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * 2, 10 * delta)
	move_and_slide()
