extends Control
signal start_the_game

func _on_Button_pressed():
	emit_signal("start_the_game")
	self.visible = false
