extends Node

@export var Obstacle0 : PackedScene
@export var Obstacle1 : PackedScene
@export var Obstacle2 : PackedScene

@onready var timerSpawn = $"TimerSpawnObstacles"

var obstacles = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	timerSpawn.start()
	for i in range(1,15):
		generateRandomObstacle()
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generateRandomObstacle():
	var obs : Node
	match randi_range(0,2):
		0:
			obs = Obstacle0.instantiate()
		1:
			obs = Obstacle1.instantiate()
		2:
			obs = Obstacle2.instantiate()
	
	obs.position = Vector2(randi_range(0,1280),randi_range(0,720))
	obstacles.append(obs)
	add_child(obs)
	return obs

func _on_timer_spawn_obstacles_timeout():
	pass
	#var obs = generateRandomObstacle()
	#add_child(obs)
	
