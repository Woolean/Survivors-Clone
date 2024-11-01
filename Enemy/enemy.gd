extends CharacterBody2D

@export var movement_speed = 65.0
@export var hp = 8
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 5

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var snd_explosion: AudioStreamPlayer = $snd_explosion
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var hitBox = $HitBox

var knockback = Vector2.ZERO
var exp_gem = preload("res://Objects/experience_gem.tscn")

signal remove_from_array(object)

func _ready():
	hitBox.damage = enemy_damage

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	
	if direction.x > 0: #Cambia la dirección del personaje segun hacia donde vaya
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true
	move_and_slide()

func death():
	animated_sprite_2d.play("explosion")
	snd_explosion.play()
	await get_tree().create_timer(0.5).timeout
	emit_signal("remove_from_array", self)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()

func _on_hurt_box_hurt(damage: Variant, angle, knockback_amount) -> void:
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_explosion.play()
