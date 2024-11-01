extends Area2D

var level = 1
var hp = 9999
var speed = 0
var damage = 10
var knockback_amount = 200
var paths = 1
var attack_size = 1.0
var attack_speed = 3.5

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var attackTimer: Timer = %AttackTimer
@onready var changeDirectionTimer: Timer = %ChangeDirection
@onready var resetPosTimer: Timer = %ResetPosTimer
@onready var snd_attack: AudioStreamPlayer2D = $snd_attack

@warning_ignore("unused_signal")
signal remove_from_array(object)

func _ready():
	update_sheep()
	_on_reset_pos_timer_timeout()

func update_sheep():
	level = player.sheep_level
	match level:
		1:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 200
			paths = 1
			attack_size = 1.0 * (1+player.spell_size)
			attack_speed = 2.5 * (1-player.spell_cooldown)
		2:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 200
			paths = 2
			attack_size = 1.0 * (1+player.spell_size)
			attack_speed = 2.5 * (1-player.spell_cooldown)
		3:
			hp = 9999
			speed = 250.0
			damage = 5
			knockback_amount = 200
			paths = 3
			attack_size = 1.0 * (1+player.spell_size)
			attack_speed = 2.5 * (1-player.spell_cooldown)
		4:
			hp = 9999
			speed = 250.0
			damage = 10
			knockback_amount = 240
			paths = 3
			attack_size = 1.0 * (1+player.spell_size)
			attack_speed = 2.5 * (1-player.spell_cooldown)
		
		
	scale = Vector2(1.0, 1.0) * attack_size
	attackTimer.wait_time = attack_speed

func _physics_process(delta: float) -> void:
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var player_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		var return_speed = 250
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_speed = 400
		position += (player_angle*return_speed*delta).normalized()

func add_paths():
	snd_attack.play()
	emit_signal("remove_from_array", self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		var direction = global_position.direction_to(new_path)
		if direction.x > 0: #Cambia la dirección del personaje segun hacia donde vaya
			animated_sprite_2d.flip_h = false
		elif direction.x < 0:
			animated_sprite_2d.flip_h = true
		
		target_array.append(new_path)
		counter += 1
		
	enable_attack(true)
	target = target_array[0]
	process_path()

func process_path():
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()

func _on_attack_timer_timeout() -> void:
	add_paths()

func _on_change_direction_timeout() -> void:
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			snd_attack.play()
			emit_signal("remove_from_array", self)
		else:
			enable_attack(false)
	else:
		changeDirectionTimer.stop()
		attackTimer.start()
		enable_attack(false)

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set", "disabled", false)
		animated_sprite_2d.play("running")
	else:
		collision.call_deferred("set", "disabled", true)
	

func _on_reset_pos_timer_timeout() -> void:
	reset_pos = player.global_position
	var choose_direction = randi() % 4
	match choose_direction:
		0: 
			reset_pos.x += 80
		1: 
			reset_pos.x += 80
		2: 
			reset_pos.y += 80
		3: 
			reset_pos.y += 80
