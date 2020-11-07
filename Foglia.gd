extends Node2D
class_name Foglia

signal falling(number) #comunico il posto che si è liberato sull'albero
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
	#dry() #chiamare da albero dopo che è caduta la foglia precedente (qui solo per test)

func dry() -> void:
	$Timer.start()

func _process(delta: float) -> void:
	position.y += 50 * delta
	if position.y > 200:
		queue_free()

func _fall() -> void:
	emit_signal("falling", index)
	set_process(true)
	pass

func _on_Timer_timeout() -> void:
	if sprite.frame_coords.y < 2:
		sprite.frame_coords.y += 1
		$Timer.start()
	else:
		_fall()
