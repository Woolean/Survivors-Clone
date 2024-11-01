extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 200
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO
signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_explosion: AudioStreamPlayer = $snd_explosion

func _ready() -> void:
	animated_sprite_2d.play("default")
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 3
			knockback_amount = 200
			attack_size = 1.0 * (1+player.spell_size)
		2:
			hp = 1
			speed = 100
			damage = 3
			knockback_amount = 200
			attack_size = 1.0 * (1+player.spell_size)
		3:
			hp = 2
			speed = 100
			damage = 6
			knockback_amount = 200
			attack_size = 1.0 * (1+player.spell_size)
		4:
			hp = 2
			speed = 100
			damage = 6
			knockback_amount = 200
			attack_size = 1.0 * (1+player.spell_size)
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", 20, 5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	
func _physics_process(delta: float) -> void:
	position += angle*speed*delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		_on_timer_timeout()

func _on_timer_timeout() -> void:
	animated_sprite_2d.play("explosion")
	snd_explosion.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
