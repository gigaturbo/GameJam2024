extends PointLight2D

@export var abs_texture_scale = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_scale = 3.0
	energy = 0.0
	abs_texture_scale = abs(texture_scale)
	texture_scale = sign(texture_scale) * abs_texture_scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	abs_texture_scale = abs(texture_scale)
	texture_scale = sign(texture_scale) * abs_texture_scale
	pass
