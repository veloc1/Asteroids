extends Sprite

export var velocityLimit = 10
export var velocityDamping = 0.8
export var accelerationLimit = 10
export var rotationVelocityLimit = 0.2
export var rotationAccelerationSpeed1 = 0.1
export var rotationAccelerationSpeed2 = 0.24
export var rotationAccelerationDumping = 0.001

var isTouchStarted
var lastCoords

var velocity
var acceleration
var rotationVelocity
var rotationAcceleration

func _ready():
	velocity = Vector2(0, 0)
	acceleration = 0
	rotationVelocity = 0
	rotationAcceleration = 0
	
	set_process(true)
	set_process_input(true)

func _process(delta):
	process_angle()
	process_translation()
	
	translate(velocity)
	rotate(rotationVelocity)

func _input(event):
	if event.type in [InputEvent.MOUSE_BUTTON]:
		isTouchStarted = event.is_pressed()
		lastCoords = event.pos
	elif event.type in [InputEvent.MOUSE_MOTION] and isTouchStarted:
		lastCoords = event.pos

func process_angle():
	if lastCoords != null:
		var angleTo = get_angle_to(lastCoords)
		rotationAcceleration = rotationAccelerationSpeed1 * angleTo
		rotationAcceleration -= rotationAccelerationSpeed2 * rotationVelocity
	
	rotationVelocity += rotationAcceleration
	rotationVelocity = clamp(rotationVelocity, -rotationVelocityLimit, rotationVelocityLimit)

func process_translation():
	if lastCoords != null and isTouchStarted:
		var distance = get_pos().distance_to(lastCoords)
		acceleration = distance
		acceleration = clamp(acceleration, -accelerationLimit, accelerationLimit)
	#else:
	#	acceleration = 0
	#	if velocity.x > 0:
	#		velocity.x = max(0, velocity.x - sin(get_rot() + 1.8) * velocityDamping)
	#	else:
	#		velocity.x = min(velocity.x + sin(get_rot()+ 1.8) * velocityDamping, 0)
	#	if velocity.y > 0:
	#		velocity.y = max(0, velocity.y - cos(get_rot()+ 1.8) * velocityDamping)
	#	else:
	#		velocity.y = min(velocity.y + cos(get_rot()+ 1.8) * velocityDamping, 0)
	
	velocity.x += sin(get_rot()) * acceleration
	velocity.y += cos(get_rot()) * acceleration
	
	velocity.x = clamp(velocity.x, -velocityLimit, velocityLimit)
	velocity.y = clamp(velocity.y, -velocityLimit, velocityLimit)
	
	var damping = Vector2(sin(get_rot() + PI / 2) * velocity.x / 100 * 30, cos(get_rot() + PI / 2)* velocity.y / 100 * 30)
	velocity.x -= damping.x
	velocity.y -= damping.y
