extends Node

@export var volume_theme_1 = -10
@export var volume_theme_2 = -7

enum mainStates {HOME, LEVEL1, LEVEL2, GAMEOVER}

var mainState = mainStates.HOME
var EndScene = preload("res://scenes/End.tscn")

@onready var MusicTheme1 = $Audio/AudioStreamPlayer_theme_1
@onready var MusicTheme2 = $Audio/AudioStreamPlayer_theme_2
@onready var HUD = $CanvasLayer/HUD
@onready var MCamera2D = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var angryMusic = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(mainState == mainStates.HOME):
		mainState = mainStates.LEVEL1
		if(true):
			startLevel(1)
	
	processMusic()
	
	if(mainState == mainStates.LEVEL1 || mainState == mainStates.LEVEL2):
		HUD.setTimer($PlayTimer.time_left)

func startLevel(level):
	print("level 1 start")
	$Player.level = level
	$PlayTimer.start()
	MusicTheme1.play()
	MusicTheme2.play()


func _on_player_point_made(newScore, balanceLevel, balanceLevelBis):
	HUD.setScore(newScore)
	HUD.setColorStats(balanceLevel*100)



func _on_player_change_evolution(playerEvolution, zoomMultiplier, shakeMultiplier, shakeSpeedMultiplierWhenBig):
	
	angryMusic = !angryMusic
	$Audio/TimerSwitchMusic.start()
		
	if(playerEvolution == "LITTLE"):
		$Player/Camera2D/TimerZoomSmoothing.start()
		MCamera2D.targetZoomX = MCamera2D.refZoom.x
		
	if(playerEvolution == "BIG"):
		$Player/Camera2D/TimerZoomSmoothing.start()
		MCamera2D.targetZoomX = MCamera2D.refZoom.x * zoomMultiplier

func _input(event):

	if event.is_action_pressed("switchMusic"):
		
		angryMusic = !angryMusic
		$Audio/TimerSwitchMusic.start()
		
		
func processMusic():
	# 0 to 1
	var musicSwitchRelative = 1.0 - $Audio/TimerSwitchMusic.time_left / $Audio/TimerSwitchMusic.wait_time
	
	if angryMusic:
		musicSwitchRelative = 1 - musicSwitchRelative
	
	var vol_theme_1 = lerp(-80, volume_theme_1, (musicSwitchRelative)**0.05)
	var vol_theme_2 = lerp(-80, volume_theme_2, (1 - musicSwitchRelative)**0.05)
	
	MusicTheme1.set_volume_db(vol_theme_1)
	MusicTheme2.set_volume_db(vol_theme_2)
	


func _on_play_timer_timeout():
	get_tree().change_scene_to_packed(EndScene)
