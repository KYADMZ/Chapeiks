extends Node2D

# Señales para comunicación
signal game_started
signal game_over

# Nodos clave
@onready var player = $Player
@onready var enemy = $Enemy
@onready var player_spawn = $SpawnPoints/PlayerStart
@onready var enemy_spawn = $SpawnPoints/EnemySpawn
@onready var ui = $UI

func _ready():
	# Conectar señales
	player.player_died.connect(_on_player_died)
	enemy.enemy_caught_player.connect(_on_player_died)
	
	# Inicializar estado
	enemy.hide()
	enemy.set_process(false)

func start_game():
	emit_signal("game_started")
	player.global_position = player_spawn.global_position
	ui.hide_start_screen()

func _on_player_reached_end():
	enemy.global_position = enemy_spawn.global_position
	enemy.show()
	enemy.set_process(true)

func _on_player_died():
	emit_signal("game_over")
	ui.show_game_over_screen()
	await get_tree().create_timer(2.0).timeout
	reset_level()

func reset_level():
	player.global_position = player_spawn.global_position
	enemy.hide()
	enemy.set_process(false)
