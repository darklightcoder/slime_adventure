extends Node2D
@onready var hud: CanvasLayer = $HUD
var level:int=1
var current_level_root:Node = null
@onready var music: AudioStreamPlayer2D = $Music
@onready var portalentry: AudioStreamPlayer2D = $portalentry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_root=get_node("baseLevel")
	
	load_level(level)
	if PlayerStats.audio_on:
		music.play()

func load_level(level_number:int)-> void:
	if level > 3:
		get_tree().change_scene_to_file("res://scenes/game_cleared.tscn")
		return
	if current_level_root:
		current_level_root.queue_free()
		
		
	var level_path ="res://scenes/levels/level_%s.tscn" %  level_number
	print(level_path)
	current_level_root=load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name="baseLevel"
	setup_level(current_level_root)

func setup_level(level_root:Node)-> void:
	var player =level_root.get_node_or_null("player")
	player.died.connect(_on_player_died)
	$HUD.set_player(player)
	var exit =level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
		
		
		
		
func _on_exit_body_entered(body:Node2D)-> void:
	print(body.name)
	
	if body.name=="player":
		body.hide()
		level += 1
		print(level)
		if(PlayerStats.audio_on):
			portalentry.play()
			await portalentry.finished
		call_deferred("load_level",level)

func _on_player_died()-> void:
	await get_tree().create_timer(1.0).timeout
	$HUD/FadeOverlay.color.a=1.0
	#var t1= get_tree().create_tween()
	#t1.tween_property($HUD/FadeOverlay,"modulate:a",1.0,1.5)
	await hud.fade(1.0)
	level=1
	print("dead")
	PlayerStats.reset()
	load_level(level)
	await hud.fade(0.0)
	#var tween = get_tree().create_tween()
	#tween.tween_property($HUD/FadeOverlay,"modulate:a",0.0,1.5)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
