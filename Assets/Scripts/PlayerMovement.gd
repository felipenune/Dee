extends KinematicBody2D

# Variables
var velocity = Vector2()

export var gravity  = 1500.0
export var wall_slide_gravity = 100.0

export var speed = 150
export var speed_default = 150
export var speed_dash = 300
export var speed_air_wall = 20

export var jump_force = -800
export var wall_jump_force = -250
export var jump_time = 0.2
var jump_timer = 0

var facing_right = true
var move_dir
var direction = Vector2()

var walk_left
var walk_right
var up
var down
var jump
var jumped = false
var jump_stop
var jump_delay
var dash

var wall_jumped
var wall_side
var on_wall

var speed_dash_side
var speed_dash_up
var dashing
var has_dash

export var shadow_color = []

# Correspondente a função Start.
func _ready():
	direction.x = scale.x

# Correspondente a função FixedUpdate.
func _physics_process(delta):
	#Inputs
	walk_left = Input.is_action_pressed("ui_left")
	walk_right = Input.is_action_pressed("ui_right")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	jump = Input.is_action_just_pressed("ui_jump")
	jump_stop = Input.is_action_just_released("ui_jump")
	dash = Input.is_action_just_pressed("ui_dash")
	
	move_dir = -int(walk_left) + int(walk_right)
	
	on_wall = $RayCast2D.is_colliding()
	
	#Gravity Logic
	if not dashing:
		velocity.y += gravity * delta
	if velocity.y > gravity:
		velocity.y += gravity * delta
		
	#Wall Slide
	if walk_left or walk_right:
		if on_wall and velocity.y > 50:
			velocity.y = 50

	#Walk Logic
	if is_on_floor():
		wall_jumped = false
		has_dash = false
		jumped = false
		
	if not dashing and not on_wall and not wall_jumped:
		velocity.x = speed * move_dir
	
	#Jump Logic
	#Coyote Jump
	if jump:
		jump_delay = true
	if jump_delay:
		jump_timer += delta
	if jump_timer >= jump_time:
		jump_delay = false
		jump_timer = 0
	#Jump with variable height
	if is_on_floor() and not dashing:
		if jump_timer > 0:
			_jump(jump_force)
	elif jump_stop and velocity.y < 0 and not wall_jumped and not dashing:
		velocity.y *= 0.5
	#Wall Jump
	if on_wall and not dashing and not is_on_floor():
		if jump:
			wall_jumped = true
			_jump(wall_jump_force)
			if facing_right:
				velocity.x += -150
			else:
				velocity.x += 150
	if wall_jumped and $wall_jump_timer.is_stopped():
		$wall_jump_timer.start()
		
	#Dash Logic
	if dash and not has_dash:
		_dash()
		Input.start_joy_vibration(0.5,0.5,0.2)
		$Ripple.visible = true
		
	# Flip Logic
	if facing_right and walk_left and not walk_right:
		_flip()
	elif not facing_right and walk_right and not walk_left:
		_flip()
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
#-------------------------------------------------------------------------

#functions
func _flip():
	facing_right = not facing_right
	scale.x *= -1
	direction.x *= -1

func _jump(force):
	velocity.y = force

func _dash():
	has_dash = true
	if walk_left:
		speed_dash_side = -speed_dash
	elif walk_right:
		speed_dash_side = speed_dash
	elif not walk_left and not walk_right and not up and not down:
		if facing_right:
			speed_dash_side = speed_dash
		else:
			speed_dash_side = -speed_dash
	else:
		speed_dash_side = 0
	if up:
		if not walk_left and not walk_right:
			speed_dash = 700
		else:
			speed_dash = 500
		speed_dash_up = -speed_dash
	elif down:
		if not walk_left and not walk_right:
			speed_dash = 700
		else:
			speed_dash = 500
		speed_dash_up = speed_dash
	else:
		speed_dash_up = 0
	dashing = true
	velocity.x = speed_dash_side
	velocity.y = speed_dash_up
	$dash_time.start()
	$spawner_timer.start()

func _on_dash_time_timeout() -> void:
	dashing = false
	speed_dash = 800
	velocity = Vector2.ZERO
	Input.stop_joy_vibration(0)
	$spawner_timer.stop()
	$Ripple.visible = false

func _on_spawner_timer_timeout() -> void:
	var shadow = load("res://Assets/Scenes/Shadow.tscn").instance()
	get_parent().add_child(shadow)
	shadow.position = position
	if facing_right:
		shadow.scale.x = 1
	else:
		shadow.scale.x = -1

func _on_wall_jump_timer_timeout() -> void:
	wall_jumped = false
