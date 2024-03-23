extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelTest1.res_instanciated.connect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _res_instanciated():
	if len($LevelTest1.resources) > 0:
		for r in $LevelTest1.resources:
			pass

func _on_resource_hit():
	print("hit")
