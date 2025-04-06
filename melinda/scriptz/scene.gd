extends Node2D

var player_scene = preload("res://playerz.tscn")
var enemy_scene = preload("res://ghost.tscn")

var player
var enemy

func _ready():
	player = player_scene.instantiate()
	add_child(player)

	enemy = enemy_scene.instantiate()
	add_child(enemy)

	enemy.position = Vector2(500, 100)
	player.position = Vector2(100, 100)

	enemy.target = player
	enemy.start_chase()  # <- LLÁMALO AQUÍ directamente


	
