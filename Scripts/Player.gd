extends KinematicBody2D

var velocity = Vector2(0,0)
const GRAVITY = 4000.0
var jump_speed = -1200
var move_speed = 500
const UP = Vector2(0,-1)
var ignore_control = false
const max_health = 100
var direction = 0

# This is how you reference the nodes created under the parent node
onready var control_timer = get_node("control_timer")
onready var collision_ray = get_node("collision_ray")
onready var pause_popup = get_node("CanvasLayer/PausePopup")
onready var resume_button = get_node("CanvasLayer/PausePopup/ColorRect/pauseOptions/PauseResumeButton")
onready var health_bar = get_node("Camera2D/HUD/ProgressBar")
onready var current_health = max_health
onready var player_in_shadow = 0

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("right") and !ignore_control:
		velocity.x = move_speed
		direction = 1
	if Input.is_action_pressed("left") and !ignore_control:
		velocity.x = -move_speed
		direction = -1
		
	if Input.is_action_just_pressed("pause"):
		pause_popup.show()
		resume_button.grab_focus()
		get_tree().paused = true
		
	move_and_slide(velocity, UP)
	
	if is_on_floor():
		velocity.y = 0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
		elif is_on_wall(): 
			ignore_control = true

			velocity.y = jump_speed
			direction = direction * -1
			velocity.x = 1000 * direction
			
			control_timer.start(.15)
				
	if control_timer.is_stopped(): # we meatboy now 
		ignore_control = false
			
	velocity.x = lerp(velocity.x, 0, 0.06)
	
	# Health is always depleteing 
	if player_in_shadow:
		current_health = current_health - .02
	else:
		current_health = current_health - .05
	
	health_bar.set("value", current_health )

func _on_Level1_player_in_shadow(in_shadow):
	player_in_shadow = in_shadow
