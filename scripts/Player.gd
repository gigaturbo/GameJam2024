extends CharacterBody2D

signal hitByRessource(ressource)
signal resourceEaten(ressource)

@export var speed = 400 # in pix/sec

var playerEvolution # TINY, LITTLE, BIG (= F0, F1, F2)
var playerMoveState = "idle" # eat, eat_poison, idle, walk_down, walk_lateral, walk_up

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var screenSize 


var resource_counter_0 = 0
var resource_counter_1 = 0
var resource_counter_2 = 0
var resource_counter_3 = 0
var resource_counter_4 = 0
var resource_counter_5 = 0

var resource_tot = 0

var score = 0

var level = 1

 # the balance bar
var coefficientOfVariationResource = 0.0
var pointMultiplier = 1.0 #

 # which percentage to which the balance bar reach a step
const CVresourceStep1 = 0.2
const CVresourceStep2 = 0.1

# called at start
func _ready():
	$AnimatedSprite2D.hide()
	setPlayerEvolution("LITTLE")
	setPlayerMoveState("idle")
	$AnimatedSprite2D.show()
	screenSize = DisplayServer.window_get_size()




func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.normalized()
	
	var mousePointingDirection = get_viewport().get_mouse_position() - screenSize*0.5
	input_direction = mousePointingDirection.normalized() 
	
	# 0 to 1
	var mouseIntensity = mousePointingDirection.length() / (screenSize.x*0.5) 
	mouseIntensity = min(mouseIntensity * (1.3), 1.0)
	
	var targetVelocity = input_direction * speed
	velocity = lerp(velocity, targetVelocity, mouseIntensity)
	
	if(Input.is_mouse_button_pressed(1)):
		velocity = velocity * 0.1

# each frame
func _physics_process(delta):
	
	
	# Movement
	get_input()
	move_and_slide()
	
	# Orientation
	if velocity.x != 0:
		$AnimatedSprite2D.set_flip_h(velocity.x < 0)
	
	
	
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
	
	# Hit only if the resource is ALIVE
	if(ressource.slimeState == ressource.SlimeState.ALIVE):
		
		$AnimatedSprite2D/PointLight2D/AnimationPlayer.stop()
		$AnimatedSprite2D/PointLight2D/AnimationPlayer.play("ligth_eating")
#		var time = Time.get_time_dict_from_system()
#		print(ressource, " entered in Player")
#		print(time) # {day:X, dst:False, hour:xx, minute:xx, month:xx, second:xx, weekday:x, year:xxxx}
#		$AnimatedSprite2D.set_modulate(Color(randf(),randf(),randf()))
		
		$AudioStreamPlayer.play()
		
		ressource.slimeState = ressource.SlimeState.EATEN
		
		resource_tot += 1
		match ressource.slimeType:
			ressource.SlimeTypeEnum.BLUE_LEVEL_1:
				resource_counter_0 += 1
			ressource.SlimeTypeEnum.PINK_LEVEL_1:
				resource_counter_1 += 1
			ressource.SlimeTypeEnum.BLUE_H1_LEVEL_2:
				resource_counter_2 += 1
			ressource.SlimeTypeEnum.BLUE_H2_LEVEL_2:
				resource_counter_3 += 1
			ressource.SlimeTypeEnum.PINK_E1_LEVEL_2:
				resource_counter_4 += 1
			ressource.SlimeTypeEnum.PINK_E2_LEVEL_2:
				resource_counter_5 += 1
				
		
		var meanResource = 1.0
		var varianceResource = 0.0
		if(level == 1):
			meanResource = 0.5*(resource_counter_0 + resource_counter_1)
			varianceResource = 0.5 * ((resource_counter_0 - meanResource)**2 + (resource_counter_1 - meanResource)**2)
		elif(level == 2):
			meanResource = 0.25*(resource_counter_2 + resource_counter_3 + resource_counter_4 + resource_counter_5)
			varianceResource = 0.25 * ((resource_counter_2 - meanResource)**2 + (resource_counter_3 - meanResource)**2 + (resource_counter_4 - meanResource)**2 + (resource_counter_5 - meanResource)**2)
			
		var standDeviationResource = sqrt(varianceResource)
		coefficientOfVariationResource = standDeviationResource / meanResource
		
		if(coefficientOfVariationResource <= CVresourceStep2):
			pointMultiplier = 5
		elif(coefficientOfVariationResource <= CVresourceStep1):
			pointMultiplier = 3
		else:
			pointMultiplier = 1
		
		var gain = 10 * pointMultiplier
		score += 10 * pointMultiplier
		
		print("+", gain, "! Score : ", score, " (CV: ", round(coefficientOfVariationResource*1000.0)*0.001, ", Multiplicateur = ", pointMultiplier, ")")


func _on_resource_eaten(ressource):
	# Put scoring logic here
	pass # Replace with function body.
