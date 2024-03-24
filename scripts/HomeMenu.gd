extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer_intro.play()
	$AudioStreamPlayer_intro.set_volume_db(-12)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_launch_button_pressed():
	$AudioStreamPlayer_intro.stop()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Credits.tscn")
