extends CharacterBody2D
var speed: float = 50.0
# Referencia al jugador (asignada automáticamente)
var player: Node2D


func _ready():
	# Busca al jugador en la escena (asegúrate de que tiene la etiqueta "Player")
	player = get_tree().get_first_node_in_group("player")
	# Alternativa: si el jugador es hijo directo de la escena principal:
	# player = get_node("../Player")

func _physics_process(delta):
	if player:
		
		# Calcula la dirección hacia el jugador (vector normalizado)
		var direction = (player.global_position - global_position).normalized()
		# Mueve al enemigo en esa dirección
		velocity = direction * speed
		
		move_and_slide()
