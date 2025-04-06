extends Node2D

@onready var player = $player
@onready var enemy = $Enemy
@onready var enemy_spawn = $Spawnpoints/enemyspawn

func _ready():
	# Conectar señales
	player.player_reached_end.connect(_on_player_reached_end)
	enemy.enemy_caught_player.connect(_on_player_died)
	
	# Posicionar enemigo fuera de pantalla inicialmente
	enemy.global_position = enemy_spawn.global_position
	enemy.hide()

func _on_player_reached_end():
	# Simular que el jugador llegó al final: activar enemigo
	enemy.global_position = enemy_spawn.global_position
	enemy.show()
	enemy.start_chasing()  # Llama a este método si usaste la versión actualizada

func _on_player_died():
	print("¡Prueba exitosa! El enemigo atrapó al jugador")
	get_tree().reload_current_scene()  # Reinicia la prueba
