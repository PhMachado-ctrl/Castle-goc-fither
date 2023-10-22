extends Area2D

@export var damage:int = 1
@onready var collision:CollisionShape2D = $Collision
@onready var disableTimer:Timer = $disableHitBoxTimer

func tempDisable():
	collision.call_deferred("set","disable", true)

func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set","disable", false)
