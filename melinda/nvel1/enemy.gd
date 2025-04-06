extends CharacterBody2D
class_name Enemy

# Señales (se mantienen igual)
signal enemy_caught_player
signal enemy_stopped

# Configuración (agregamos seguridad para el nodo player)
@export var speed: float = 70.0
@export var activation_radius: float = 400.0
var is_chasing: bool = false

# Nodos (con verificación de existencia)
@onready var animation_ghost: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
var player: Node2D  # Cambiamos @onready por asignación manual

func _ready():
	# Asignación segura del player
	player = get_tree().get_first_node_in_group("Player")
	
	# Verificación EXTRA-robusta
	if detection_area == null:
		printerr("DetectionArea es null - Añade el nodo Area2D al enemigo")
		return
		
	if not detection_area.body_entered.is_connected(_on_detection_area_body_entered):
		var connect_result = detection_area.body_entered.connect(_on_detection_area_body_entered)
		if connect_result != OK:
			printerr("Fallo al conectar señal:", connect_result)
		else:
			print("Señal body_entered conectada correctamente")

func _physics_process( _delta ):
	if !player or !is_chasing:
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Animaciones (versión simplificada)
	if velocity.length() > 0.1:
		animation_ghost.play("walk", -1, 1.0, false)  # Forzar reproducción
		sprite.flip_h = direction.x < 0

	
# Funciones de control (se mantienen igual)
func start_chasing():
	if !player:
		player = get_tree().get_first_node_in_group("playerr")  # Reintentar obtener player
		
	is_chasing = true
	set_physics_process(true)
	
	

func stop_chasing():
	is_chasing = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	emit_signal("enemy_stopped")

# Detección de colisión (con verificación adicional)
func _on_detection_area_body_entered(body):
	if body == null: return
	print("Cuerpo detectado:", body.name)
	if body.is_in_group("Player"):
		print("🔥 ¡Enemigo atrapó al jugador!")
		emit_signal("enemy_caught_player")
 # Debug
