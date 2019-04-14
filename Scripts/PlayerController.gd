extends KinematicBody

var InputDirection = Vector3(0, 0, 0)

var gravity = -16
var Velocity = Vector3()
onready var camera = get_node("../Camera").global_transform
var moving = false
const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5
const JUMP_FORCE = 9
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	camera = get_node("../Camera").global_transform
	var moving = false
	InputDirection = Vector3(0, 0, 0)
	
	GetInput()
	Velocity(delta)

	Velocity = move_and_slide(Velocity, Vector3(0,1,0))

	
func GetInput():
	if(Input.is_action_pressed("move_up")):
		InputDirection += -camera.basis[2]
		moving = true
		get_node("../Camera").playerAjusted = false
	if(Input.is_action_pressed("move_down")):
		InputDirection += camera.basis[2]
		moving = true
		get_node("../Camera").playerAjusted = false
	if(Input.is_action_pressed("move_left")):
		InputDirection += -camera.basis[0]
		moving = true
		get_node("../Camera").playerAjusted = false
	if(Input.is_action_pressed("move_right")):
		InputDirection += camera.basis[0]
		moving = true
		get_node("../Camera").playerAjusted = false
		
	if Input.is_action_pressed("Jump") and is_on_floor():
		Velocity.y += JUMP_FORCE
		
func Velocity(delta):
	InputDirection.y = 0
	InputDirection = InputDirection.normalized()
	
	Velocity.y += delta * gravity
	
	var hv = Velocity
	hv.y = 0

	var new_pos = InputDirection * SPEED
	var accel = DE_ACCELERATION

	if (InputDirection.dot(hv) > 0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	Velocity.x = hv.x
	Velocity.z = hv.z
	
	if moving:
		# Rotate the player to direction
		var angle = atan2(hv.x, hv.z)
		var char_rot = self.get_rotation()
		char_rot.y = angle
		self.set_rotation(char_rot)