extends Control

onready var timer = get_node("Timer")
onready var blu: Bidone = $Bidone/Blu
onready var rosso: Bidone = $Bidone/Rosso
onready var verde: Bidone = $Bidone/Verde
onready var giallo: Bidone = $Bidone/Giallo
var bidoni = [blu, rosso, verde, giallo]

#in base al punteggio attuale, diminuisce il tempo di spawn
#vedi spawnTime(score)
var score = 2

func _ready() -> void:
	timer.set_wait_time(spawnTime(score))
	initialize()

func initialize() -> void:
	blu.type = 0
	rosso.type = 1
	verde.type = 2
	giallo.type = 3 #vanno settati qui perché export rende la variabile globale

func _process(delta: float) -> void:
	timer.set_wait_time(spawnTime(score))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_blue"):
		blu.active = true
	if event.is_action_pressed("select_red"):
		rosso.active = true
	if event.is_action_pressed("select_green"):
		verde.active = true
	if event.is_action_pressed("select_yellow"):
		giallo.active = true

func _on_Timer_timeout():
	#una persona viene spawnata
	var personaScene = load("res://Persona.tscn")
	var personaInstance = personaScene.instance() #vedi Persona.gd -> ready()
	get_node("Persone").add_child(personaInstance)
	personaInstance.connect("spawn", self, "_on_trash_throw")

func spawnTime(score) -> float:
	return 3+(4/(score+1))

func _on_trash_throw(trashPosition):
	var rifiutoScene = load("res://Rifiuto.tscn")
	var rifiutoInstance = rifiutoScene.instance()
	rifiutoInstance.initialize(trashPosition)
	get_node("Rifiuti").add_child(rifiutoInstance);
