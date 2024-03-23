extends RigidBody2D


var velocity = Vector2.ZERO
var speed = 0
var spawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.hide()
	start()

func start():
	spawned = true
	changeBehavior()
	$AnimatedSprite2D.show()
	$TimerChangeDirection.start()
	

func changeBehavior():
	velocity = Vector2.from_angle(randf() * 2* PI).normalized()
	speed = randi_range(5,10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawned:
		position = position + velocity * speed * delta


func _on_timer_change_direction_timeout():
	changeBehavior()
	
	
