extends Control

var blueBar
var redBar
# Called when the node enters the scene tree for the first time.
func _ready():
	blueBar = $"MarginContainer/HSplitContainer/Color Stats Container/Color Progress Bars/VSplitContainer/BlueProgress"
	redBar = $"MarginContainer/HSplitContainer/Color Stats Container/Color Progress Bars/VSplitContainer/RedProgress"
	init()
	
func init():
	blueBar.value = 0
	redBar.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	addColorStat(delta * 1, delta * 2)


func setColorStats(blue, red):
	blueBar.value = clampf(blue, 0, 100)
	redBar.value = clampf(red, 0, 100)

func addColorStat(blue, red):
	setColorStats(blueBar.value + blue, redBar.value + red)
	
	
	
