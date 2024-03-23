extends RigidBody2D

@export var impulseSpeed = 50 # impulse speed in pix/sec
@export var maxSpeed = 100 # in pix/sec

var velocity = Vector2.ZERO
var speed = 0
var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.hide()
	set_lock_rotation_enabled(true)
	set_contact_monitor(true)
	max_contacts_reported = 3


	start()

func start():
	spawned = true
	$AnimatedSprite2D.show()
	$TimerChangeDirection.start()
	randomImpulseMove(impulseSpeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_change_direction_timeout():
	randomImpulseMove(impulseSpeed)
	
	if linear_velocity.length() > maxSpeed:
		linear_velocity = linear_velocity.normalized() * maxSpeed

func randomImpulseMove(anImpulseSpeed):
	# stop me
	linear_velocity = Vector2(0, 0)

	# give me an impulse
	var x_impulse = 0.5 - randf() # from -0.5 to 0.5, no unit
	var y_impulse = 0.5 - randf() # from -0.5 to 0.5, no unit
	var impulse_vec = Vector2(x_impulse, y_impulse).normalized() * anImpulseSpeed
	apply_impulse(impulse_vec)



func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	var time = Time.get_time_dict_from_system()
	print(body, " entered")
	print(time) # {day:X, dst:False, hour:xx, minute:xx, month:xx, second:xx, weekday:x, year:xxxx}
	$AnimatedSprite2D.set_modulate(Color(randf(),randf(),randf()))
