extends Area2D

signal resHit

@export var impulseSpeed = 50 # impulse speed in pix/sec
@export var maxSpeed = 100 # in pix/sec
@export var brakingSpeed = 10 # in pix/sec/sec

var state = "OK" # OK TOUCHED DEAD
var velocity = Vector2.ZERO
var speed = 0
var spawned = false
var listenedByLevel = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.hide()
#	set_lock_rotation_enabled(true)
#	set_contact_monitor(true)
#	max_contacts_reported = 3
	start()

func start():
	spawned = true
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
	resHit.emit() # Emit a signal to the parent to play sounds
	var time = Time.get_time_dict_from_system()
	#print(body, " entered")
	#print(time) # {day:X, dst:False, hour:xx, minute:xx, month:xx, second:xx, weekday:x, year:xxxx}
	$AnimatedSprite2D.set_modulate(Color(randf(),randf(),randf()))
	#print(is_instance_of(body, CharacterBody2D))
