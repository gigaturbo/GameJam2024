extends Area2D

enum SlimeTypeEnum {BLUE_LEVEL_1, PINK_LEVEL_1, BLUE_H1_LEVEL_2, BLUE_H2_LEVEL_2, PINK_E1_LEVEL_2, PINK_E2_LEVEL_2}
enum RandomSlimeLevel2Enum {OFF, RANDOM_BLUE, RANDOM_PINK, RANDOM_VARIANT1, RANDOM_VARIANT2}

@export var impulseSpeed = 50 # impulse speed in pix/sec
@export var maxSpeed = 100 # in pix/sec
@export var brakingSpeed = 10 # in pix/sec/sec

@export_group("SLIME TYPE SETTINGS |!| Random level_2 prio. sur level_1 |!|")
@export var slimeType : SlimeTypeEnum
@export var randomizeSlimeColorLevel1 : bool = false
@export var randomizeSlimeLevel2 : RandomSlimeLevel2Enum = RandomSlimeLevel2Enum.OFF

var state = "OK" # OK TOUCHED DEAD
var velocity = Vector2.ZERO
var speed = 0
var spawned = false

# Called when the node enters the scene tree for the first time.

func _ready():
	$AnimatedSprite2D.hide()
#	set_lock_rotation_enabled(true)
#	set_contact_monitor(true)
#	max_contacts_reported = 3
	$AnimatedSprite2D.position = Vector2(300,300)
	start()


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
	
	
func start():
	spawned = true
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
	$TimerChangeDirection.start()
	randomImpulseMove(impulseSpeed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	velocity -= velocity.normalized() * brakingSpeed * delta
	pass


func _on_timer_change_direction_timeout():
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


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):	
	body.hitByRessource.emit(self)
