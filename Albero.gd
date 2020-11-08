extends Node2D

signal gameover

export (PackedScene) var Foglia_scene
var free_pos := [-1, 1, -2, 2, -3, 3, -4, 4, -5, 5] #posizioni libere
var MAX_SCORE := 10
var score := MAX_SCORE setget set_score

var current_leaf: Foglia = null
var next_leaf: Foglia = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

func reset() -> void:
	$Timer.stop()
	score = 10
	for idx in free_pos:
		add_leaf(idx)
	free_pos = []
	$Timer.start()
	current_leaf = $Foglie.get_child(0)
	next_leaf = $Foglie.get_child(1)

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

func set_score(value: int) -> void:
	if value < score:
		score = max(0, value)
		if check_gameover():
			return
		if next_leaf != null:
			next_leaf.fall()
			next_leaf = fall_leaf(next_leaf)
	elif value > score:
		score = min(value, MAX_SCORE)
		if free_pos.size() > 0:
			add_leaf(free_pos[0])
			free_pos.remove(0)
		else:
			pass # make leaves green again

func fall_leaf(leaf: Foglia) -> Foglia:
	if leaf == null:
		print("GAME OVER (tried to remove extra leaves)")
		emit_signal("gameover")
	free_pos.append(leaf.index)
	$Foglie.remove_child(leaf)
	$Cadenti.add_child(leaf)
	
	var next: Foglia = null
	if $Foglie.get_child_count() > 1:
		next =  $Foglie.get_child(1) #shoud alway be 1 
	return next

func check_gameover() -> bool:
	if score <= 0:
		print("GAME OVER")
		emit_signal("gameover")
		$Timer.stop()
		return true
	return false

func _on_Timer_timeout() -> void:
	if current_leaf.dry(): #if it falls, switch leaves and change group
		score -= 1 #decrease score (no setter to avoid falling other leaves)
		if check_gameover():
			return
		
		var next_next = fall_leaf(current_leaf)
		current_leaf = next_leaf
		next_leaf = next_next
