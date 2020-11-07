extends Node2D

signal gameover

export (PackedScene) var Foglia_scene
var free_pos := [-1, 1, -2, 2, -3, 3, -4, 4, -5, 5] #posizioni libere
var MAX_SCORE := 10
var score := MAX_SCORE setget set_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()
	pass # Replace with function body.

func reset() -> void:
	score = 10
	for idx in free_pos:
		add_leaf(idx)
	free_pos = []
	var next: Foglia = $Foglie.get_child(0)
	next.dry()

#solo test
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("action"):
#		self.score += 1

func add_leaf(index: int) -> void:
	var leaf: Foglia = Foglia_scene.instance()
	var _position: Vector2
	if index < 0:
		var pos: Position2D = $LeftPos.get_child(-index -1)
		_position = pos.global_position + Vector2(-24,0) #offset per compensare flip
	else:
		var pos: Position2D = $RightPos.get_child(index -1)
		_position = pos.global_position
	$Foglie.add_child(leaf)
	leaf.initialize(_position, index)
	leaf.connect("falling", self, "_leaf_did_fall")

func _leaf_did_fall(index) -> void:
	print("Leaf falling " + str(index))
	score -= 1 #non chiama self.score per non forzare la caduta di altre foglie
	free_pos.append(index)
	if $Foglie.get_child_count() <= 1: #chiamato prima di queue free quindi ancora 1 dentro
		print("GAME OVER")
		emit_signal("gameover")
	else:
		var next: Foglia = $Foglie.get_child(1) #chiamato prima di queue free
		next.dry()

func set_score(value: int) -> void:
	if value < score:
		score = max(0, value)
		# potrebbe essere dovuto ad un errore del giocatore -> forze caduta
		# per non forzare la caduta di foglie non chiamare con self.score
		pass
	elif value > score:
		score = min(value, MAX_SCORE)
		if free_pos.size() > 0:
			add_leaf(free_pos[0])
			free_pos.remove(0)
		else:
			pass # make leaves green again
