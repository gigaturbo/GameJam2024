extends Control


var timerRemaining
var isPaused = true

@onready var blueBar = $"MarginContainer/HSplitContainer/Color Stats Container/Color Progress Bars/VSplitContainer/BlueProgress"
@onready var redBar = $"MarginContainer/HSplitContainer/Color Stats Container/Color Progress Bars/VSplitContainer/RedProgress"
@onready var label = $"MarginContainer2/LabelTimer"
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	
func init(timerValue= 3*60):
	isPaused = true
	setColorStats(0, 0)
	setTimerSeconds(timerValue)

func setPaused(paused):
	isPaused = paused

	# Set the remaining timer label from `timerRemaining`
func setTimerLabel():
	label.text = str("Timer", "\n", int(timerRemaining/60),"'", int(timerRemaining - int(timerRemaining/60)*60), "''")

func setTimerSeconds(s):
	timerRemaining = s
	setTimerLabel()

func removeTimerSeconds(s):
	setTimerSeconds(timerRemaining - s)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if not isPaused:
	#	addColorStat(delta * 1, delta * 2)
	#	removeTimerSeconds(delta)

# Sets the color bar values
func setColorStats(blue, red):
	blueBar.value = clampf(blue, 0, 100)
	redBar.value = clampf(red, 0, 100)

# Add a value to the color bars 
func addColorStat(blue, red):
	setColorStats(blueBar.value + blue, redBar.value + red)
	
