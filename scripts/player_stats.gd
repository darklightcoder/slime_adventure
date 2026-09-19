extends Node

var max_health:int=100
var health:int=100
var audio_on:bool=true

func reset() -> void:
	health = max_health
