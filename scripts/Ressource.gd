extends RigidBody2D

enum SlimeTypeEnum {BLUE_LEVEL_1, PINK_LEVEL_1, BLUE_H1_LEVEL_2, BLUE_H2_LEVEL_2, PINK_E1_LEVEL_2, PINK_E2_LEVEL_2}
enum RandomSlimeLevel2Enum {OFF, RANDOM_BLUE, RANDOM_PINK, RANDOM_VARIANT1, RANDOM_VARIANT2}
enum SlimeState {ALIVE, EATEN}

@export var impulseSpeed = 5 # impulse speed in pix/sec
@export var maxSpeed = 7 # in pix/sec
@export var brakingSpeed = 4 # in pix/sec/sec

@export_group("SLIME TYPE SETTINGS |!| Random level_2 prio. sur level_1 |!|")
@export var slimeType : SlimeTypeEnum
@export var randomizeSlimeColorLevel1 : bool = false
@export var randomizeSlimeLevel2 : RandomSlimeLevel2Enum = RandomSlimeLevel2Enum.OFF

var velocity = Vector2.ZERO
var speed = 0
var spawned = false
var slimeState = SlimeState.ALIVE
var targetBody : Node2D = null
@onready var timerEaten = $TimerEaten
# Called when the node enters the scene tree for the first time.

func _ready():
	$AnimatedSprite2D.hide()
	start()


func start():
	spawned = true
	slimeState = SlimeState.ALIVE
	# Set slime sprite according to slimeType
	if randomizeSlimeColorLevel1: # Simple random choice
		match randi_range(0,1):
			0:
				slimeType = SlimeTypeEnum.BLUE_LEVEL_1
			1:
				slimeType = SlimeTypeEnum.PINK_LEVEL_1

	if randomizeSlimeLevel2 != RandomSlimeLevel2Enum.OFF:
		match randomizeSlimeLevel2:
			RandomSlimeLevel2Enum.RANDOM_BLUE:
				match randi_range(0,1):
					0:
						slimeType = SlimeTypeEnum.BLUE_H1_LEVEL_2
					1:
						slimeType = SlimeTypeEnum.BLUE_H2_LEVEL_2
			RandomSlimeLevel2Enum.RANDOM_PINK:
				match randi_range(0,1):
					0:
						slimeType = SlimeTypeEnum.PINK_E1_LEVEL_2
					1:
						slimeType = SlimeTypeEnum.PINK_E2_LEVEL_2
			RandomSlimeLevel2Enum.RANDOM_VARIANT1:
				match randi_range(0,1):
					0:
						slimeType = SlimeTypeEnum.BLUE_H1_LEVEL_2
					1:
						slimeType = SlimeTypeEnum.PINK_E1_LEVEL_2
			RandomSlimeLevel2Enum.RANDOM_VARIANT2:
				match randi_range(0,1):
					0:
						slimeType = SlimeTypeEnum.BLUE_H2_LEVEL_2
					1:
						slimeType = SlimeTypeEnum.PINK_E2_LEVEL_2

	$AnimatedSprite2D.animation = getAnimationName("idle")
	$AnimatedSprite2D.show()
	$TimerChangeDirection.wait_time = (randf() * 1.5) + 0.5
	$TimerChangeDirection.start()
	randomImpulseMove(impulseSpeed)
	
	# velocity cap
	if velocity.length() > maxSpeed:
		velocity = velocity.normalized() * maxSpeed


func getAnimationName(action):
	var anim = ""
	# TODO: set collisions boxes for 1-5
	$CollisionShape2D_0.disabled = false
	$CollisionShape2D_1.disabled = true
	$CollisionShape2D_2.disabled = true
	$CollisionShape2D_0.show()
	$CollisionShape2D_1.hide()
	$CollisionShape2D_2.hide()
	match slimeType:
		SlimeTypeEnum.BLUE_LEVEL_1:
			anim = str(anim, "0")
		SlimeTypeEnum.PINK_LEVEL_1:
			anim = str(anim, "1")
		SlimeTypeEnum.BLUE_H1_LEVEL_2:
			anim = str(anim, "2")
		SlimeTypeEnum.BLUE_H2_LEVEL_2:
			anim = str(anim, "3")
		SlimeTypeEnum.PINK_E1_LEVEL_2:
			anim = str(anim, "4")
		SlimeTypeEnum.PINK_E2_LEVEL_2:
			anim = str(anim, "5")
	
	return str(anim, "_", action)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if slimeState == SlimeState.ALIVE:
		velocity -= velocity.normalized() * brakingSpeed * delta
		move_and_collide(velocity)
	elif slimeState == SlimeState.EATEN:
		var targetDirection = targetBody.global_position - global_position
		brakingSpeed = 0
		$AnimatedSprite2D.scale = Vector2(1,1) * (1 - (timerEaten.wait_time - timerEaten.time_left))
		velocity = targetDirection.normalized() * maxSpeed * 10
		position += velocity * delta
		if timerEaten.time_left <= 0 or targetDirection.length() < 25:
			targetBody.resourceEaten.emit(self)
			self.queue_free()
			
		
func _on_timer_change_direction_timeout():
	if slimeState == SlimeState.ALIVE:
		randomImpulseMove(impulseSpeed)
		# velocity cap
		if velocity.length() > maxSpeed:
			velocity = velocity.normalized() * maxSpeed


func randomImpulseMove(anImpulseSpeed):
	# give me an impulse
	var x_impulse = 0.5 - randf() # from -0.5 to 0.5, no unit
	var y_impulse = 0.5 - randf() # from -0.5 to 0.5, no unit
	var impulse_vec = Vector2(x_impulse, y_impulse).normalized() * anImpulseSpeed
	velocity = impulse_vec

# Notify player it has ben hit by resource, also start animating resource in EATEN mode
func _on_body_shape_entered(body_rid, body : Node2D, body_shape_index, local_shape_index):	
	if is_instance_of(body, CharacterBody2D):
		body.hitByRessource.emit(self)
		targetBody = body
		slimeState = SlimeState.EATEN
		timerEaten.start()
	else:
		print("Resource touche something")

