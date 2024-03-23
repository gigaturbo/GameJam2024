extends CharacterBody2D


@export var speed = 400 # in pix/sec

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.normalized()
	velocity = input_direction * speed

func _physics_process(delta):
	# Movement
	get_input()
	move_and_slide()
	
	# Orientation
	if Input.get_vector("left", "right", "up", "down").x != 0:
		$AnimatedSprite2D.set_flip_h(Input.get_vector("left", "right", "up", "down").x < 0)
	
