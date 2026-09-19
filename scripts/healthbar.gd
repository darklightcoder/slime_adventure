extends Node2D
@onready var health_bar: Sprite2D = $health
@onready var default_width = health_bar.region_rect.size.x
@onready var default_height = health_bar.region_rect.size.y

func update_health(new_health:int) -> void:
	var new_width = (new_health/100.0) * default_width
	health_bar.region_rect = Rect2(0,0,new_width,default_height)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
