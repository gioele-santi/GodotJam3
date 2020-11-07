extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/Play.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$CenterContainer/VBoxContainer/Play.visible = true
		$CenterContainer/VBoxContainer/Howto.visible = true
		$CenterContainer/VBoxContainer/Credits.visible = true
		$CenterContainer/VBoxContainer/Quit.visible = true
		
		$CenterContainer/VBoxContainer/CreditsText.visible = false
		$CenterContainer/VBoxContainer/HowtoText.visible = false
#	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Mondo.tscn")


func _on_Credits_pressed():
	hidemenu()
	$CenterContainer/VBoxContainer/CreditsText.visible = true


func _on_Quit_pressed():
	get_tree().quit()


func _on_Howto_pressed():
	hidemenu()
	$CenterContainer/VBoxContainer/HowtoText.visible = true
	

func hidemenu():
	$CenterContainer/VBoxContainer/Play.visible = false
	$CenterContainer/VBoxContainer/Howto.visible = false
	$CenterContainer/VBoxContainer/Credits.visible = false
	$CenterContainer/VBoxContainer/Quit.visible = false
	
