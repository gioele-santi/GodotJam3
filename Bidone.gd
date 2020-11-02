extends KinematicBody2D
class_name Bidone

onready var sprite = $Sprite

# Impostazione tipo
enum BIN_TYPE {BLUE, RED, GREEN, YELLOW}
var type = BIN_TYPE.BLUE setget set_type
var textures := {
	'blue': "res://asset/sprite/bidone_blu.png",
	'red': "res://asset/sprite/bidone_rosso.png",
	'green': "res://asset/sprite/bidone_verde.png",
	'yellow':"res://asset/sprite/bidone_giallo.png"
}

var active := false setget set_active
var posizione = 0
# Called when the node enters the scene tree for the first time.

var bumpable := true
var bump_once := true

func _ready() -> void:
	pass # Replace with function body.

func set_type(value) -> void:
	type = value
	var text_name: String = ''
	match type:
		BIN_TYPE.BLUE:
			text_name = 'blue'
		BIN_TYPE.RED:
			text_name = 'red'
		BIN_TYPE.GREEN:
			text_name = 'green'
		BIN_TYPE.YELLOW:
			text_name = 'yellow'
	if sprite != null: 
		sprite.texture = load(textures[text_name])

func set_active(value: bool) -> void:
	if value == active:
		return
	active = value
	if active:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")

func _physics_process(delta):
	#print($RayCast2D.get_collider())
	if active==true:
		var velocity=Vector2()
		if Input.is_key_pressed(KEY_RIGHT):
			velocity.x=+500
		if Input.is_key_pressed(KEY_LEFT):
				 velocity.x=-500
		if Input.is_action_just_pressed("ui_up"):
			if posizione==1:
				if $RayCast2D.is_colliding()==false: 
					position.y-=40
					position.x+=40
					posizione=0
		if Input.is_action_just_pressed("ui_down"):
			if posizione==0:
				if $RayCast2D.is_colliding()==false:
					position.y+=40
					position.x-=40
					posizione=1
		var collision = move_and_collide(velocity * delta)
		if collision:
			if collision.collider.has_method("_bump") and bump_once: 
				bump_once = false
				collision.collider._bump()
		else:
			bump_once = true

func _bump() -> void:
	if bumpable:
		bumpable = false
		$AnimationPlayer.play("bump")

func _on_Area2D_area_entered(area):
	if(area is Rifiuto):
		area.queue_free() #si potrebbe aggiungere un'animazione per farlo sparire gradualmente
		if(area.type == self.type):
			print("Punteggio e salute aumentati - suono _ok_")
		else:
			$AnimationPlayer.play("full")
			print("Salute diminuita - suono _hai sbagliato_")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "bump":
		bumpable = true
