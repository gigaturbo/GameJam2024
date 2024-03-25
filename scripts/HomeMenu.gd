extends Node2D

var Main_Scene = preload("res://scenes/Main.tscn")
var Credits_Scene = preload("res://scenes/Credits.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer_intro.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_launch_button_pressed():
	$AudioStreamPlayer_intro.stop()
	get_tree().change_scene_to_packed(Main_Scene)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	get_tree().change_scene_to_packed(Credits_Scene)
