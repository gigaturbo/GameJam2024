extends RigidBody2D

enum SlimeTypeEnum {NORMAL_BLUE, NORMAL_PINK, POISON_BLUE, POISON_PINK}
enum SlimeState {ALIVE, EATEN}

@export var impulseSpeed = 5 # impulse speed in pix/sec
@export var maxSpeed = 7 # in pix/sec
@export var brakingSpeed = 4 # in pix/sec/sec

@export_group("SLIME TYPE SETTINGS |!| Poisonous prio. over Normal")
@export var slimeType : SlimeTypeEnum = SlimeTypeEnum.NORMAL_BLUE
@export var randomizeSlimeNormal : bool = false
@export var randomizeSlimePoisonous : bool = false

var velocity = Vector2.ZERO
var speed = 0
var spawned = false
var slimeState = SlimeState.ALIVE
var targetBody : Node2D = null
var isPoisonous = false
@onready var timerEaten = $TimerEaten
# Called when the node enters the scene tree for the first time.

func _ready():
	$AnimatedSprite2D.hide()
	start()


func start():
	spawned = true
	slimeState = SlimeState.ALIVE
	# Set slime sprite according to slimeType
	if randomizeSlimeNormal: # Simple random choice
		match randi_range(0,1):
			0:
				slimeType = SlimeTypeEnum.NORMAL_BLUE
			1:
				slimeType = SlimeTypeEnum.NORMAL_PINK
				
	if randomizeSlimePoisonous: # Simple random choice poisonous
		match randi_range(0,1):
			0:
				slimeType = SlimeTypeEnum.POISON_BLUE
			1:
				slimeType = SlimeTypeEnum.POISON_PINK

	if (slimeType == SlimeTypeEnum.POISON_BLUE) or (slimeType == SlimeTypeEnum.POISON_PINK):
		isPoisonous = true 

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
	# TODO: set colgittgithlisions boxes for 1-5
	$CollisionShape2D_0.disabled = false
	$CollisionShape2D_1.disabled = true
	$CollisionShape2D_2.disabled = true
	$CollisionShape2D_0.show()
	$CollisionShape2D_1.hide()
	$CollisionShape2D_2.hide()
	match slimeType:
		SlimeTypeEnum.NORMAL_BLUE:
			anim = str(anim, "0")
		SlimeTypeEnum.NORMAL_PINK:
			anim = str(anim, "1")
		SlimeTypeEnum.POISON_BLUE:
			anim = str(anim, "2")
		SlimeTypeEnum.POISON_PINK:
			anim = str(anim, "3")
	
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
		velocity = targetDirection.normalized() * maxSpeed * 3
		move_and_collide(velocity)
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
	pass



func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_of(body, CharacterBody2D):
		body.hitByRessource.emit(self)
		targetBody = body
		slimeState = SlimeState.EATEN
		timerEaten.start()
