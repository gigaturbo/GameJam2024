extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		$AudioStreamPlayer.stop()
		get_tree().change_scene_to_file("res://scenes/HomeMenu.tscn")


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/HomeMenu.tscn")
