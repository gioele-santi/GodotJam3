extends Control

onready var timer = get_node("Timer")
onready var blu: Bidone = $Bidone/Blu
onready var rosso: Bidone = $Bidone/Rosso
onready var verde: Bidone = $Bidone/Verde
onready var giallo: Bidone = $Bidone/Giallo
onready var bidoni = [blu, rosso, verde, giallo]

onready var albero: Albero = $Albero

#in base al punteggio attuale, diminuisce il tempo di spawn
#vedi spawnTime(score)
var score = 0
var playing := false

var bgm = load("res://asset/audio/bgm/bgm1.wav")

func _ready() -> void:
	timer.set_wait_time(spawnTime(score))
	blu.type = 0
	rosso.type = 1
	verde.type = 2
	giallo.type = 3 
	
	$AudioStreamPlayer.stream = bgm
	$AudioStreamPlayer.play()

func start_game() -> void:
	playing = true
	select_bidone(0)
	score = 0

func select_bidone(idx: int) ->void:
	for i in range (0, 4):
		bidoni[i].active = i == idx

func _process(delta: float) -> void:
	timer.set_wait_time(spawnTime(score))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_red"):
		select_bidone(0)
	if event.is_action_pressed("select_green"):
		select_bidone(1)
	if event.is_action_pressed("select_blue"):
		select_bidone(2)
	if event.is_action_pressed("select_yellow"):
		select_bidone(3)

func _on_Timer_timeout():
	#una persona viene spawnata
	var personaScene = load("res://Persona.tscn")
	var personaInstance = personaScene.instance() #vedi Persona.gd -> ready()
	get_node("Persone").add_child(personaInstance)
	personaInstance.connect("spawn", self, "_on_trash_throw")

func spawnTime(score) -> float:
	if score >= 15:
		return 1.5
	else:
		return score*(-0.2)+4.5

func _on_trash_throw(trashPosition):
	var rifiutoScene = load("res://Rifiuto.tscn")
	var rifiutoInstance = rifiutoScene.instance()
	rifiutoInstance.initialize(trashPosition)
	rifiutoInstance.speed = rifiutoInstance.speed + score
	get_node("Rifiuti").add_child(rifiutoInstance);

func refreshScore():
	$Score/RichTextLabel.bbcode_text = "[center][rainbow]"
	$Score/RichTextLabel.bbcode_text += str(score)

func scoreUp():
	score = score + 1
	albero.score += 1
	refreshScore()
	#-------
	
func scoreDown():
	albero.score -= 1
	#-------

func _on_Albero_gameover() -> void:
	get_tree().change_scene("res://Gameover.tscn")
