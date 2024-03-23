extends CharacterBody2D

signal hitByRessource(ressource)
signal resourceEaten(ressource)

@export var speed = 400 # in pix/sec

var playerEvolution = "BIG" # TINY, LITTLE, BIG (= F0, F1, F2)
var playerMoveState = "idle" # eat, eat_poison, idle, walk_down, walk_lateral, walk_up

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# called at start
func _ready():
	$AnimatedSprite2D.hide()
	setPlayerEvolution("BIG")
	setPlayerMoveState("idle")
	$AnimatedSprite2D.show()


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.normalized()
	velocity = input_direction * speed

# each frame
func _physics_process(delta):
	# Movement
	get_input()
	move_and_slide()
	
	# Orientation
	if Input.get_vector("left", "right", "up", "down").x != 0:
		$AnimatedSprite2D.set_flip_h(Input.get_vector("left", "right", "up", "down").x < 0)
	
	
	
func setPlayerMoveState(moveState):
	var animName = ""
	match playerEvolution:
		"TINY":
			animName = "F0"
		"LITTLE":
			animName = "F1"
		"BIG":
			animName = "F2"
	animName = str(animName, "_", moveState)
	
	$AnimatedSprite2D.animation = animName

# evolution level = TINY LITTLE or BIG
func setPlayerEvolution(playerEvolution_):
	playerEvolution = playerEvolution_
	match playerEvolution_:
		"TINY":
			$CollisionShape2D_F0.disabled = false
			$CollisionShape2D_F1.disabled = true
			$CollisionShape2D_F2.disabled = true
			$CollisionShape2D_F0.show()
			$CollisionShape2D_F1.hide()
			$CollisionShape2D_F2.hide()
		"LITTLE":
			$CollisionShape2D_F0.disabled = true
			$CollisionShape2D_F1.disabled = false
			$CollisionShape2D_F2.disabled = true
			$CollisionShape2D_F0.hide()
			$CollisionShape2D_F1.show()
			$CollisionShape2D_F2.hide()
		"BIG":
			$CollisionShape2D_F0.disabled = true
			$CollisionShape2D_F1.disabled = true
			$CollisionShape2D_F2.disabled = false
			$CollisionShape2D_F0.hide()
			$CollisionShape2D_F1.hide()
			$CollisionShape2D_F2.show()
	setPlayerMoveState(playerMoveState)



func _on_hit_by_ressource(ressource):
	var time = Time.get_time_dict_from_system()
	$AnimatedSprite2D.set_modulate(Color(randf(),randf(),randf()))
	print(ressource, " entered in Player")
	print(time) # {day:X, dst:False, hour:xx, minute:xx, month:xx, second:xx, weekday:x, year:xxxx}
	pass # Replace with function body.


func _on_resource_eaten(ressource):
	# Put scoring logic here
	pass # Replace with function body.
