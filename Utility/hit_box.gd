extends Area2D

@export var damage = 5
@onready var disableTimer: Timer = $DisableHitBoxTimer
@onready var collision: CollisionShape2D = $CollisionShape2D

func tempdisable():
	collision.call_deferred("set","disabled",true)
	disableTimer.start()

func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disabled",false)
