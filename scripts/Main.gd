extends Node

enum mainStates {HOME, LEVEL1, LEVEL2, GAMEOVER}

var mainState = mainStates.HOME

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(mainState == mainStates.HOME):
		mainState = mainStates.LEVEL1
		if(true):
			startLevel(2)
	
	
	if(mainState == mainStates.LEVEL1 || mainState == mainStates.LEVEL2):
		$CanvasLayer/HUD.setTimer($PlayTimer.time_left)

func startLevel(level):
	print("level 1 start")
	$Player.level = level
	$PlayTimer.start()


func _on_player_point_made(newScore, balanceLevel, balanceLevelBis):
	$CanvasLayer/HUD.setScore(newScore)
	$CanvasLayer/HUD.setColorStats(balanceLevel)
	pass # Replace with function body.
