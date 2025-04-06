extends CharacterBody2D

# Velocidad de movimiento del enemigo

# Configurables desde el Inspector
@export var speed: float = 150.0
var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
