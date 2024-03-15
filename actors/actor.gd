class_name Actor

extends CharacterBody3D

@onready
var state_machine: StateMachine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup the state machine
	state_machine.init(self)

# let the state machine handle things
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

# let the state machine handle things
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

# let the state machine handle things
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
