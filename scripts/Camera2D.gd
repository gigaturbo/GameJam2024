extends Camera2D

var targetZoomX
var refZoom
var refZoomX

# Called when the node enters the scene tree for the first time.
func _ready():
	targetZoomX = zoom.x
	refZoom = zoom
	refZoomX = zoom.x
	print("zoom ", zoom)
	pass
#	position_smoothing_enabled = false
#	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $TimerZoomSmoothing.time_left > 0 :
		
		print("\nbase zoom ", zoom)
		var relativeTimeSpend: float =  1.0 - $TimerZoomSmoothing.time_left / $TimerZoomSmoothing.wait_time 
		
		var actualZoomX = zoom.x
		var zoomRatio = lerp(actualZoomX, targetZoomX, relativeTimeSpend)
		
		print("actualZoomX ", actualZoomX, ", targetZoomX ", targetZoomX, ", relativeTimeSpend ", round(relativeTimeSpend*100.0)/100.0)
		print("zoomRatio ", zoomRatio)
		
		zoom.x = refZoom.x / refZoomX * zoomRatio
		zoom.y = refZoom.y / refZoomX * zoomRatio
		print("refZoom ", refZoom)
		print("zoom ", zoom)
	pass
	


func _on_timer_timeout():
	pass
#	position_smoothing_enabled = true
