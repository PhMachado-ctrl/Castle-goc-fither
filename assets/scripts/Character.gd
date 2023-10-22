extends CharacterBody2D

enum  {
	ATTACK,
	MOVE
}

@export_category('Player Stats')
@export var walk_speed:float = 85
@export var hp: int = 80

@onready var sprite:AnimatedSprite2D = $Sprite
@onready var collision:CollisionShape2D = $Marker2D/Attack/HitBox
@onready var timer:Timer = get_node("%AttackTimer") # Timer for can or not attack

var state = MOVE
var can_attatk:bool = true
var first_punch:bool = true
var first_kick:bool = true
var is_punching:bool = false #is_punch verification
var is_kicking:bool = false #is_kick verifications


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	state_machine(_delta)

# Change Animations and Player States
func state_machine(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()

func move_state(delta):
	""" Movement """
	var move = Vector2.ZERO
	# Input movement
	move.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	move.normalized()
	velocity = move * walk_speed * delta
	
	# Animation walk and Idle
	if velocity != Vector2.ZERO:
		sprite.play("Walk")
	else:
		sprite.play("Idle")
	
	# Flip the Sprite player and collision
	if velocity.x < 0: 
		sprite.flip_h = true
		collision.position.x = -13
		collision.scale.x = 1.7
	elif velocity.x > 0:
		sprite.flip_h = false
		collision.position.x = 20
		collision.scale.x = 1.7
	move_and_collide(velocity)
	
	'''      Attacks Inputs    '''
	# First Punch
	if Input.is_action_just_pressed("punch") and can_attatk and first_punch:
		first_punch = false
		is_punching = true
		is_kicking = false
		basic_attack_config()
	
	# Second Punch
	if Input.is_action_just_pressed("punch") and can_attatk and !first_punch:
		first_punch = true
		is_punching = true
		is_kicking = false
		basic_attack_config()
	
	# First Kick
	if Input.is_action_just_pressed("kick") and can_attatk and first_kick:
		first_kick = false
		is_kicking = true
		is_punching = false
		basic_attack_config()
	
	# Second Kick
	if Input.is_action_just_pressed("kick") and can_attatk and !first_kick:
		first_kick = true
		is_kicking = true
		is_punching = false
		basic_attack_config()
	
# Parameter iguals in all attacks
func basic_attack_config():
	collision.call_deferred("set", "disabled", false)
	can_attatk = false
	state = ATTACK
	timer.start()

func attack_state():
	# Animation punch left and right
	if is_punching and first_punch:
		sprite.play("Punch_Left")
	elif is_punching and !first_punch:
		sprite.play("Punch_Right")
	
	# Animation kick left and right
	if is_kicking and first_kick:
		sprite.play("Kick_right")
	elif is_kicking and !first_kick:
		sprite.play("Kick_left")
	
	
	
func _on_timer_timeout():
	collision.call_deferred("set","disabled", true) 
	can_attatk = true
	state = MOVE
