extends Area2D

const  help_effect:int  = 20
@onready var collected_sound: AudioStreamPlayer2D = $collectedSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body.name=="player":
		body.heal(help_effect)
		collision_shape_2d.set_deferred("disabled",true)
		visible=false
		if PlayerStats.audio_on:
			collected_sound.play()
			await collected_sound.finished
		queue_free()
