extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
@export var engine_force_value = 40

var steer_target = 0


func _physics_process(delta):

#	$motor_noise.pitch_scale=self.linear_velocity.length()/24
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
 
#	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"

	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("ui_up"):
		
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value * 12 / speed, 0, 300)
   
		else:
			engine_force = engine_force_value
   
	else:
		engine_force = 0

	if Input.is_action_pressed("ui_down"):
 
		# Increase engine force at low speeds to make the initial acceleration faster.
  
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value * 4 / speed, 0, 300)
				
			else:
				engine_force = -engine_force_value
    
		else:
			brake = 1
   
	else:
		brake = 0.0
		
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)


func traction(speed):
	apply_central_force(Vector3.DOWN*speed)
