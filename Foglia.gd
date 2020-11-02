extends Node2D
class_name Foglia

signal falling(number) #comunico il posto che si è liberato sull'albero
var index := -1
onready var sprite = $Sprite

func _ready() -> void:
	set_process(false)

func initialize(pos: Vector2, number: int, delay: int = 0) -> void:
	position = pos
	index = number
	#usare il delay per ritardare la partenza del timer e mantenere un pò di equilibrio
	$AnimationPlayer.play("setup")


func _process(delta: float) -> void:
	position.y += 50 * delta


func fall() -> void:
	emit_signal("falling", index)
	set_process(true)
	pass

func _on_Timer_timeout() -> void:
	print("Foglia timeout")
	if sprite.frame_coords.y < 2:
		sprite.frame_coords.y += 1
	else:
		fall()
	pass # Replace with function body.
