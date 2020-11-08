extends Node2D
class_name Foglia

var index := -1
onready var sprite = $Sprite

func _ready() -> void:
	set_process(false)
	initialize(Vector2(40, 0), -1)

func initialize(pos: Vector2 = Vector2.ZERO, number: int = 0) -> void:
	global_position = pos
	index = number
	$Sprite.flip_h = index < 0
	$AnimationPlayer.play("setup")

func dry() -> bool:
	if sprite.frame_coords.y < 2:
		sprite.frame_coords.y += 1
		return false
	else:
		set_process(true)
		return true

func fall() -> void:
	sprite.frame_coords.y = 2
	set_process(true)

func _process(delta: float) -> void:
	position.y += 50 * delta
	if position.y > 200:
		queue_free()
		set_process(false)
