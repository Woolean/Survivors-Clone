extends Node2D

@export var experience = 1

var spr_green = preload("res://Textures/Items/Gems/G_Idle.png")
var spr_blue = preload("res://Textures/Items/Gems/G_Idle.png")
var spr_red = preload("res://Textures/Items/Gems/G_Idle.png")

var target = null
var speed = -1

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var sound: AudioStreamPlayer = %snd_collected


func _ready() -> void:
	pass
	if experience < 5:
		return 
	elif experience < 25:
		sprite.play("default_green")
	else:
		sprite.play("default_purple")
	
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience
	

func _on_snd_collected_finished() -> void:
	queue_free()
