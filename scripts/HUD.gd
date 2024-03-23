extends Control


var timerRemaining
var isPaused = true


@onready var blueBar = $"MarginContainer/HSplitContainer/Color Stats Container/Color Progress Bars/VBoxContainer/BlueProgress"

# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	
func init(timerValue= 3*60):
	isPaused = true
	setColorStats(0)

func setPaused(paused):
	isPaused = paused




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update timer from the main scene
	pass

# Sets the color bar values
func setColorStats(blue):
	blueBar.value = clampf(blue, 0, 100)

# Add a value to the color bars 
func addColorStat(blue):
	setColorStats(blueBar.value + blue)
	

func setScore(score):
	$MarginContainer3/LabelScore.text = "Score\n" + str(score)
	
	
# timeleft in s
func setTimer(timeleft):
	$MarginContainer2/LabelTimer.text = "Time\n" + str(round(timeleft))
