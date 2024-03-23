extends Node2D

signal res_intanciated

@export var resource : PackedScene
@export var MAX_RESOURCES : int = 7
var resources = []
# Called when the node enters the scene tree for the first time.
func _ready():
	start()


func start():
	$TimerSpawn.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_spawn_timeout():
	if len(resources) < MAX_RESOURCES:
		var res  = resource.instantiate()
		res.position = Vector2(randi_range(0, 1280), randi_range(0, 720))
		add_child(res)
		resources.append(res)
		res_intanciated.emit()
	
