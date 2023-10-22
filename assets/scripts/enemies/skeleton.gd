extends CharacterBody2D

@export_category('Enemy Stats')
@export var move_speed: float = 20.0
@export var hp: int = 10


@onready var anim: AnimatedSprite2D = $Texture

@onready var player = get_tree().get_first_node_in_group("player")

func _ready()-> void:
	anim.play("walk")
	
func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	move_and_slide()
	
	if direction.x > 0.1:
		anim.flip_h = false
	elif direction.x < -0.1:
		anim.flip_h = true

