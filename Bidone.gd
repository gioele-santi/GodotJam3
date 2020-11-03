extends KinematicBody2D
class_name Bidone

onready var sprite = $Sprite

# Impostazione tipo
enum BIN_TYPE {RED, GREEN, BLUE, YELLOW}
var type = BIN_TYPE.BLUE setget set_type
var textures := {
	'red': "res://asset/sprite/bidone_rosso_num.png",
	'green': "res://asset/sprite/bidone_verde.png",
	'blue': "res://asset/sprite/bidone_blu_num.png",
	'yellow':"res://asset/sprite/bidone_giallo_num.png"
}

var active := false setget set_active
var posizione = 0 #corsia 0 oppure 1
const horizontalShift = 80 #numero pixel spostamento orrizontale
var verticalShift_y = 30
var verticalShift_x = 20

var bumpable := true
var bump_once := true

func _ready() -> void:
	pass # Replace with function body.

func set_type(value) -> void:
	type = value
	var text_name: String = ''
	match type:
		BIN_TYPE.RED:
			text_name = 'red'
		BIN_TYPE.GREEN:
			text_name = 'green'
		BIN_TYPE.BLUE:
			text_name = 'blue'
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

func _process(delta):
	movementInput()

func movementInput() -> void:
	if(active == false):
		return
	var newPosition = get_position()
	
	if Input.is_action_just_pressed("ui_left"):
		if($LeftRaycast.is_colliding() == false):
			newPosition.x -= horizontalShift
			
	else: if Input.is_action_just_pressed("ui_right"):
		if($RightRaycast.is_colliding() == false):
			newPosition.x += horizontalShift
			
	else: if Input.is_action_just_pressed("ui_up"):
		if($UpRaycast.is_colliding() == false):
			newPosition.x += verticalShift_x
			newPosition.y -= verticalShift_y
	
	else: if Input.is_action_just_pressed("ui_down"):
		if($DownRaycast.is_colliding() == false):
			newPosition.x -= verticalShift_x
			newPosition.y += verticalShift_y
	
	($".").set_position(newPosition)
		

func _bump() -> void:
	if bumpable:
		bumpable = false
		$AnimationPlayer.play("bump")

func _on_Area2D_area_entered(area):
	var sfx
	if(area is Rifiuto):
		area.queue_free() #si potrebbe aggiungere un'animazione per farlo sparire gradualmente
		if(area.type == self.type):
			scoreUp()
			if(area.type == 1):
				sfx = load("res://asset/audio/sfx/glass.wav")
			else:
				sfx = load("res://asset/audio/sfx/trash_in_can.wav")
		else:
			scoreDown()
			$AnimationPlayer.play("full")
			sfx = load("res://asset/audio/sfx/wrong.wav")
		$AudioStreamPlayer.stream = sfx
		$AudioStreamPlayer.play()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "bump":
		bumpable = true

func scoreUp():
	print("Punteggio e salute aumentati - suono _ok_")
	pass

func scoreDown():
	print("Salute diminuita - suono _hai sbagliato_")
	pass

#deprecated _physics_process
#func _physics_process(delta):
#	#print($RayCast2D.get_collider())
#	if active==true:
#		var velocity=Vector2()
#		if Input.is_key_pressed(KEY_RIGHT):
#			velocity.x=+500
#		if Input.is_key_pressed(KEY_LEFT):
#				 velocity.x=-500
#		if Input.is_action_just_pressed("ui_up"):
#			if posizione==1:
#				if $RayCast2D.is_colliding() == false and $RayCast2D2.is_colliding() == false and velocity.x == 0: 
#					position.y-=40
#					position.x+=40
#					posizione=0
#		if Input.is_action_just_pressed("ui_down"):
#			if posizione==0:
#				if $RayCast2D.is_colliding() == false and $RayCast2D2.is_colliding() == false and velocity.x == 0 :
#					position.y+=40
#					position.x-=40
#					posizione=1
#		var collision = move_and_collide(velocity * delta)
#		if collision:
#			if collision.collider.has_method("_bump") and bump_once: 
#				bump_once = false
#				collision.collider._bump()
#		else:
#			bump_once = true
