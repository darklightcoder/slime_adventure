extends CanvasLayer

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var hearts_box: HBoxContainer = $hearts
const heart_size:int=20

const h_full = preload("res://assets/heart1.png")
const h_half = preload("res://assets/heart2.png")
const h_empty = preload("res://assets/heart3.png")
var player

func set_player(p)-> void:
	player=p
	if player:
		player.health_changed.connect(update_health)
		update_health(player.health)
# Called when the node enters the scene tree for the first time.
func fade(toAlpha:float) -> void:
	var tween = create_tween()
	print("tween called")
	tween.tween_property(fade_overlay,"modulate:a",toAlpha,1.5)
	await tween.finished

func update_health(newhealth:int) -> void:
	var hearts=hearts_box.get_children()
	var max_hearts=len(hearts)
	var full = int(newhealth/heart_size)
	var half = 1 if (newhealth % heart_size) > 0 else 0
	var empty = max_hearts - (full + half)
	for i in full:
		hearts[i].texture=h_full
	if half:
		hearts[full].texture=h_half	
	for i in empty:
		hearts[len(hearts)-1-i].texture=h_empty
