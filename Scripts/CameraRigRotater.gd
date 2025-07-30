extends Node3D

var rotation_amount = 90  # degrees
var rotating = false
var rotation_speed = 180  # degrees per second
var initial_rotation = 0.0  # initial y angle
var direction = 0

func _process(delta):
	# Check if rotation is in progress
	if rotating:
		# Calculate new rotation based on linear interpolation
		var current_rotation = self.rotation_degrees.y
		var target_rotation = 0
		var rotation_direction = 0
		
		if direction > 0:
			target_rotation = initial_rotation - rotation_amount
			rotation_direction = sign(target_rotation - initial_rotation)
		elif direction < 0:
			target_rotation = initial_rotation + rotation_amount
			rotation_direction = sign(initial_rotation - target_rotation)
		
		# Calculate ease factor for smoother easing (only ease-out)
		var ease_factor = 1.0 - ease_in_out_quad(1.0 - abs(current_rotation - initial_rotation) / rotation_amount)

		# Ensure a minimum ease factor for ease-out
		if ease_factor < 0.4:
			ease_factor = 0.4

		var new_rotation = 0
		# Update rotation based on rotation speed and ease factor
		if  direction > 0:
			new_rotation = current_rotation + delta * rotation_speed * rotation_direction * ease_factor
		elif  direction < 0:
			new_rotation = current_rotation + delta * rotation_speed * rotation_direction * ease_factor
		
		# Check if rotation should be limited
		if direction < 0 and new_rotation > target_rotation:
			new_rotation = target_rotation
			rotating = false  # Stop rotating once rotation is complete
		elif direction > 0 and new_rotation < target_rotation:
			new_rotation = target_rotation
			rotating = false  # Stop rotating once rotation is complete

		# Apply the new rotation to the node
		self.rotation_degrees.y = new_rotation

	# Update rotation based on user input
	if not rotating:  # Check if not rotating
		if Input.is_action_just_pressed("rotate_left"):
			if self.rotation_degrees.y >= 360:
				self.rotation_degrees.y = self.rotation_degrees.y - 360
			elif self.rotation_degrees.y <= -360:
				self.rotation_degrees.y = self.rotation_degrees.y + 360
				
			rotating = true
			rotation_speed = abs(rotation_speed)  # Set rotation speed to positive for left rotation
			initial_rotation = self.rotation_degrees.y  # Record the initial y angle
			direction = 1
		elif Input.is_action_just_pressed("rotate_right"):
			if self.rotation_degrees.y >= 360:
				self.rotation_degrees.y = self.rotation_degrees.y - 360
			elif self.rotation_degrees.y <= -360:
				self.rotation_degrees.y = self.rotation_degrees.y + 360
				
			rotating = true
			rotation_speed = -abs(rotation_speed)  # Set rotation speed to negative for right rotation
			initial_rotation = self.rotation_degrees.y  # Record the initial y angle
			direction = -1

# Custom easing function for smooth ease-out
func ease_in_out_quad(t):
	return 2.0 - (t*t)
