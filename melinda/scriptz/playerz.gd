class_name playerz extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var state : String = "idle"
var movement_speed: float = 100.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	pass

func _process(delta):
	
	direction.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	direction.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	
	velocity = direction * movement_speed
	
	if setState() == true || setDirection()== true:
		UpdateAnimation()	
	pass
func _physics_process( delta ): 
	move_and_slide()

func setDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
		
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func setState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state :
		return false
	state = new_state
	return true
	


func UpdateAnimation()	-> void:
	animation_player.play(state+"_"+AnimDirection())
	pass	

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"	
