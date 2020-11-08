extends MarginContainer

func _ready():
	var bgm = load("res://asset/audio/bgm/gameover.wav")
	$AudioStreamPlayer.stream = bgm
	$AudioStreamPlayer.play()
	$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Menu.tscn")
