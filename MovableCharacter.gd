extends CharacterBody3D

var animation_player

var awaiting_dest = false #Boolean indicating whether we're awaiting a mouse click
var max_speed = 10 #Maximum speed of the character
var speed = 0 #Current speed of the character
var acceleration = 20 #Acceleration with which the speed approaches max_speed
#var move_direction #Move direction as input for the animation player
var moving = false #Boolean that indicates if the character is moving
var destination = Vector3() # Location where the mouse click happened
var movement = Vector3() # The movement we will push to the engine

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = get_node("/root/Main/Character/AnimationPlayer")
	var move_button = get_node("/root/Main/PlayerMenu/MoveButton")
	move_button.move_button_pressed.connect(handle_move_button_pressed)

func _unhandled_input(event): #function that will take any unhandled input
	if awaiting_dest and event.is_action_pressed('left_click'):
		awaiting_dest = false
		moving = true
		
		# Do the raycast
		var space_state = get_world_3d().direct_space_state
		var mouse_pos = get_viewport().get_mouse_position()
		var camera = get_tree().root.get_camera_3d()
		
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
		var ray_params = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var ray_array = space_state.intersect_ray(ray_params)
		if ray_array.has("position"):
			destination = ray_array["position"]
		look_at(destination, Vector3.UP)
		rotate(Vector3.UP, PI) #Otherwise the character faces backwards
		play_animation("Walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	movement_loop(delta)
	
func handle_move_button_pressed():
	awaiting_dest = true
	
func movement_loop(delta):
	if moving == false:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 1:
		velocity = movement
		movement = move_and_slide()
	else:
		play_animation("Idle")
		moving = false

func play_animation(name):
	animation_player.play(name)
