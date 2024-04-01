extends State

class_name DeathState

# run when the state is entered
func enter() -> void:
	parent.change_animation('Death')
