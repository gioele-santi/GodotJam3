#tool
extends Area2D
class_name Rifiuto

onready var sprite = $Sprite

# Impostazione tipo
enum TRASH_TYPE {APPLE, BOTTLE, MILK, JUICE}
var type = TRASH_TYPE.APPLE setget set_type
var textures := {
	'apple': "res://asset/sprite/torsolo.png",
	'bottle': "res://asset/sprite/bottiglia.png",
	'milk': "res://asset/sprite/cartone_latte.png",
	'juice': "res://asset/sprite/succo.png"
}

export (int) var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta):
	move(delta)

func initialize(position: Vector2) -> void:
	self.position = position
	set_type(randi()%textures.size())
	pass

func set_type(value) -> void:
	type = value
	var text_name: String = ''
	match type:
		TRASH_TYPE.APPLE:
			text_name = 'apple'
		TRASH_TYPE.BOTTLE:
			text_name = 'bottle'
		TRASH_TYPE.MILK:
			text_name = 'milk'
		TRASH_TYPE.JUICE:
			text_name = 'juice'
	if $Sprite != null: 
		$Sprite.texture = load(textures[text_name])

func move(delta):
	var exPos = get_position()
	exPos.y += (delta * speed)
	set_position(Vector2(exPos.x, exPos.y))
