class_name Playerf
extends CharacterBody2D

# Señales para comunicación con Main
signal player_reached_end()  # Cuando llega al final del mapa
signal player_died()        # Cuando el enemigo lo atrapa

# Variables de movimiento
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var state : String = "idle"
@export var movement_speed: float = 100.0
var can_move: bool = true  # Para bloquear movimiento en cutscenes

# Nodos
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox  # ¡Asegúrate de tener un Area2D para detectar al enemigo!

func _ready():
	hitbox.body_entered.connect(_on_body_entered)

func _process(_delta):
	if !can_move:
		return
		
	# Input handling
	direction.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	direction.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	
	velocity = direction * movement_speed
	
	if setState() || setDirection():
		UpdateAnimation()

func _physics_process(_delta):
	if can_move:
		move_and_slide()
		_check_end_of_map()

# --- Lógica de animación (sin cambios) ---
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
	if new_state == state:
		return false
	state = new_state
	return true

func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

# --- Nuevas funcionalidades ---
func _check_end_of_map():
	# Ajusta este valor según el final de tu mapa
	if global_position.x >= 1000:  # Ejemplo: coordenada X del final
		emit_signal("player_reached_end")

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		emit_signal("player_died")

func toggle_movement(allow: bool):
	can_move = allow
	if !allow:
		velocity = Vector2.ZERO
		state = "idle"
		UpdateAnimation()
