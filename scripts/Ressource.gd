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
@onready var initScale = self.global_scale * 1.0
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
		$CharacterEffects/PointLight2D_res/AnimationPlayer.play("i_am_poison")
		$CharacterEffects/PointLight2D_res.texture_scale = 7
		

	# Add a bit of randomness in the direction changes
	$TimerChangeDirection.wait_time = (randf() * 2.5) + 0.5 # 0.5 to 3
	$AnimatedSprite2D.animation = getAnimationName("idle")
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
	$TimerChangeDirection.start()
	randomImpulseMove(impulseSpeed)
	
	# velocity cap
	if velocity.length() > maxSpeed:
		velocity = velocity.normalized() * maxSpeed


func getAnimationName(action):
	var anim = ""
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
		$AnimatedSprite2D.speed_scale = (velocity.length()/maxSpeed) * 2.5 + 0.5
		move_and_collide(velocity)
	elif slimeState == SlimeState.EATEN:
		$AnimatedSprite2D.speed_scale = 1
		var targetDirection = targetBody.global_position - global_position
		brakingSpeed /= 2
		var animScale = timerEaten.time_left / timerEaten.wait_time # 1 ->0
		self.scale = initScale * animScale
		velocity = targetDirection.normalized() * maxSpeed
		move_and_collide(velocity)
		if timerEaten.time_left <= 0 or targetDirection.length() < 5:
			targetBody.resourceEaten.emit(self)
			self.queue_free()
			
		
func _on_timer_change_direction_timeout():
	if slimeState == SlimeState.ALIVE:
		randomImpulseMove(impulseSpeed)
		# velocity cap
		if velocity.length() > maxSpeed:
			velocity = velocity.normalized() * maxSpeed


func randomImpulseMove(anImpulseSpeed):
	if randf()< 0.8: # 80% chance to move 
		# Random impulse direction
		var v = Vector2.from_angle(randf() * 2 * PI)
		# Add randomness around "anImpulseSpeed" value, but not less than zero
		self.velocity = v * max(anImpulseSpeed  + randfn(0, 0.5), 0)
	else: # 20% to stay still
		velocity = Vector2.ZERO


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if is_instance_of(body, CharacterBody2D):
		body.hitByRessource.emit(self)
		targetBody = body
		slimeState = SlimeState.EATEN
		$AnimatedSprite2D.animation = getAnimationName("eaten")
		timerEaten.start()
