extends Area2D

@export var impulseSpeed = 50 # impulse speed in pix/sec
@export var maxSpeed = 100 # in pix/sec
@export var brakingSpeed = 10 # in pix/sec/sec
@export var slimeColor : int  = 0 # Two colors of slimes : 0 to 1
@export var slimeHat : int = 0 # Two hats of slimes : 0 to 2
@export var randomizeSlimeColor : bool = false
@export var randomizeSlimeHat : bool = false

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
	start()


func getAnimationName(action):
	var anim = ""
	match slimeColor:
		0:
			anim = str(anim, "A")
		1:
			anim = str(anim, "B")
	match slimeHat:
		0:
			anim = str(anim, "0")
			$CollisionShape2D_0.disabled = false
			$CollisionShape2D_1.disabled = true
			$CollisionShape2D_2.disabled = true
			$CollisionShape2D_0.show()
			$CollisionShape2D_1.hide()
			$CollisionShape2D_2.hide()
		1:
			anim = str(anim, "1")
			$CollisionShape2D_0.disabled = true
			$CollisionShape2D_1.disabled = false
			$CollisionShape2D_2.disabled = true
			$CollisionShape2D_0.hide()
			$CollisionShape2D_1.show()
			$CollisionShape2D_2.hide()
		2:
			anim = str(anim, "2")
			$CollisionShape2D_0.disabled = true
			$CollisionShape2D_1.disabled = true
			$CollisionShape2D_2.disabled = false
			$CollisionShape2D_0.hide()
			$CollisionShape2D_1.hide()
			$CollisionShape2D_2.show()
			
	return str(anim, "_", action)
	

func start():
	spawned = true
	if randomizeSlimeColor:
		slimeColor = randi_range(0,1)
	if randomizeSlimeHat:
		slimeHat = randi_range(0,2)

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
	var time = Time.get_time_dict_from_system()
	$AnimatedSprite2D.set_modulate(Color(randf(),randf(),randf()))
	#print(body, " entered")
	#print(time) # {day:X, dst:False, hour:xx, minute:xx, month:xx, second:xx, weekday:x, year:xxxx}
	#print(is_instance_of(body, CharacterBody2D))
