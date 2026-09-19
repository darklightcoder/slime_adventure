extends Node2D
@onready var check_box: CheckBox = $CheckBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_box.button_pressed=PlayerStats.audio_on
	
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")





func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerStats.audio_on=true
	else:
		PlayerStats.audio_on=false
