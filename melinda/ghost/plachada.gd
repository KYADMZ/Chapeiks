extends Node2D

@export var speed: float = 100.0
@export var target: CharacterBody2D


@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  

var chasing := false

func _ready():
	
	visible = false
	set_process(false)

	await get_tree().create_timer(5.0).timeout

	if target:
		print("Target found, starting chase!")
		start_chase()
	else:
		print("No target assigned yet, retrying...")

		# Intentar esperar más si aún no está asignado
		await get_tree().create_timer(1.0).timeout
		if target:
			print("Target finally assigned!")
			start_chase()
		else:
			print("Still no target. Giving up.")


func start_chase():
	visible = true
	chasing = true

	if animation_player.has_animation("appear"):
		animation_player.play("appear")
		await animation_player.animation_finished

	set_process(true)

func _process(delta):
	if chasing and target:
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta
		update_animation(direction)

func update_animation(dir: Vector2):
	animation_player.play("move")
