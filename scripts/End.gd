extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.set_volume_db(-16)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://scenes/HomeMenu.tscn")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/HomeMenu.tscn")



func _on_label_score_ready():
	$"Panel/LabelScore".text = "[center][b][i]" + str(10000) + "[/i][/b][/center]"
