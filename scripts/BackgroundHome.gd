extends Sprite2D

var randx = randf() * 1000 
var randy = randf() * 1000 

var moveIntensity = 2

var resPosition
# Called when the node enters the scene tree for the first time.
func _ready():
	scale *= 1.05
	resPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x = resPosition.x + sin(randx + Time.get_ticks_msec() * 0.5 * 0.1 * 0.001 * 2*PI) * moveIntensity
	position.y = resPosition.y + sin(randy + Time.get_ticks_msec() * 0.85 * 0.1 * 0.001 * 2*PI) * moveIntensity
