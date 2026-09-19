extends CharacterBody2D

signal died 
signal health_changed(new_health:int)

@onready var asprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing_sword: AudioStreamPlayer2D = $swingSword
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var damage_countdown: Timer = $damageCountdown

var last_dir :Vector2=Vector2.RIGHT
var hitbox_offset :Vector2=Vector2.RIGHT
@onready var hit_box: Area2D = $hitBox
var max_health:int
var health:int
var alive:bool=true
var strenght :int=20

var is_attacking :bool=false
const SPEED = 300.0
@onready var portal: AnimatedSprite2D = $"../Exit/portal"

func _ready() -> void:
	hitbox_offset=hit_box.position
	max_health = PlayerStats.max_health
	health = PlayerStats.health
	portal.play('idle')
func  heal(amount:int)-> void:
	health += amount
	if health > max_health:
		health=max_health
	PlayerStats.health = health
	emit_signal("health_changed",health)

func update_hb_offset() -> void:
	var x = hitbox_offset.x
	var y = hitbox_offset.y
	if last_dir==Vector2.LEFT:
		hit_box.position=Vector2(-x,y)
	elif last_dir==Vector2.RIGHT:
		hit_box.position=Vector2(x,y)
	elif last_dir==Vector2.UP:
		hit_box.position=Vector2(y,-x)
	elif last_dir==Vector2.DOWN:
		hit_box.position=Vector2(y,x)
		
func take_damage(damage:int) -> void:
	
	if alive:
		if damage_countdown.time_left > 0 :
			return
		if PlayerStats.audio_on:
			audio.play()
		health -= damage
		print(health)
		PlayerStats.health=health

		emit_signal("health_changed",health)
		#health_changed.emit(health)
		if health<=0:
			die()
	else:
		return
		
	
	
	#healthbar.update_health(health)		
	damage_countdown.start()
	

func die()-> void:
	asprite_2d.play("die")
	alive=false
	await asprite_2d.animation_finished
	died.emit()

		
func _physics_process(delta: float) -> void:
	hit_box.monitoring=false
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	if alive:
		if Input.is_action_just_pressed("attack") and not is_attacking:
			play_attack()
			
		if is_attacking:
			velocity=Vector2.ZERO
			return
			
		process_movement()
		proccess_animation()
		move_and_slide()

func proccess_animation():
	if is_attacking:
		return
	if velocity != Vector2.ZERO:
		play_animation("run",last_dir)
	else :
		play_animation("idle",last_dir)
		
func process_movement() -> void:
	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	if direction !=Vector2.ZERO:
		velocity = direction * SPEED
		last_dir = direction
		update_hb_offset()
	else :
		velocity = Vector2.ZERO
		
	
func play_animation(prefix:String,dir:Vector2) -> void:
	if(dir.x!= 0):
		asprite_2d.flip_h=dir.x < 0
		asprite_2d.play(prefix+"_right")
	if(dir.y> 0):
		asprite_2d.play(prefix+"_down")
	elif(dir.y< 0):
		asprite_2d.play(prefix+"_up")
	if(dir.x< 0):
		asprite_2d.play(prefix+"_left")
		
	
func play_attack() -> void:
	is_attacking=true
	hit_box.monitoring=true

	play_animation("attack",last_dir)
	if PlayerStats.audio_on:
		swing_sword.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	if is_attacking and body.name.begins_with("slime"):
		print("Attack")
		body.take_damage(20,position)
