extends CharacterBody2D
@onready var healthbar: Node2D = $healthbar


@onready var attack_timer: Timer = $attackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D =$AudioStreamPlayer2D
const SPEED = 10.0

const drop_chance:float=1.0
var hp_sceene= preload("res://scenes/health_pickup.tscn")
var target = null
var target_in_range:bool=false
var health:int=100
var Force:int=100
var is_alive = true
var strength:int = 10
func _physics_process(delta: float) -> void:
	if is_alive and target :
		_attack(delta)

	move_and_slide()

func _attack(delta:float)-> void:
	if is_alive:
		var direction = (target.position-position).normalized()
		position += direction * SPEED * delta
		animated_sprite_2d.play("attack")
	
	
func _on_sight_body_entered(body: Node2D) -> void:
	if body.name=="player":
		target = body

func take_damage(damage:int, attacker_dir:Vector2) -> void:
	health -= damage
	healthbar.update_health(health)
	if PlayerStats.audio_on:
		audio.play()
	if health <= 0:
		audio.stop()
		die()
	var knockback_dir = (position - attacker_dir).normalized()
	var target_pos = position + knockback_dir * Force
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"position",target_pos,0.5)
	
func die():
	is_alive=false
	animated_sprite_2d.play("die")
	audio.pitch_scale=0.5
	#audio.play()
	$CollisionShape2D.set_deferred("disabled",true)
	$sight/CollisionShape2D.set_deferred("disabled",true)
	$hitBox/CollisionShape2D.set_deferred("disabled",true)
	healthbar.queue_free()
	if randf() <= drop_chance:
		drop_Item()

func drop_Item():
	var drop = hp_sceene.instantiate()
	drop.position = position
	var level_root= get_parent()
	var items_node = level_root.get_node("items")
	items_node.call_deferred("add_child",drop)

func _on_sight_body_exited(body: Node2D) -> void:
	if body.name=="player":
		target = null
		if is_alive:
			animated_sprite_2d.play("idle")


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name=="player":
		target_in_range=true
		body.take_damage(strength)
		attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if target and target_in_range :
		target.take_damage(strength)


func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.name=="player":
		target_in_range=false
		#body.take_damage(strength)
		attack_timer.stop()
