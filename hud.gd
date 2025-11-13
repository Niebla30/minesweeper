extends CanvasLayer

var game_over = false
signal new_game
signal maybe_won
var passed_time = 0

'''
POSITION EVERY SCENE
'''
func position_buttons(columns):
	var y = 57
	$Mode.position.y = y
	$Smile.position.y = y
	$Settings.position.y = y
	$BombsLeft.position.y = y
	$Time.position.y = y
	$SettingsConfig.position.y = 170

	$Mode.position.x = (columns-1)*40 + 27
	$Settings.position.x = 60
	$Smile.position.x = ($Mode.position.x + $Settings.position.x) / 2
	$BombsLeft.position.x = $Mode.position.x - 65
	$Time.position.x = ($Smile.position.x + $Settings.position.x) / 2
	$SettingsConfig.position.x = ($Mode.position.x + $Settings.position.x) / 2
	
	$SettingsConfig.hide()

'''
HANDLE BOMB COUNTER
'''
func set_number_of_bombs(n):
	if n == 0:
		$BombsLeft/Message.text = str(n)
		maybe_won.emit()
	elif n < 0:
		$BombsLeft/Message.text = "?"
	else:
		$BombsLeft/Message.text = str(n)
		
'''
HANDLE GAME OVER AND NEW GAME
'''
func died():
	game_over = true
	$Smile.play("died")
	$Timer.stop()

func _on_smile_button_button_down():
	if game_over:
		$Smile.play("dead_pressed")
	else:
		$Smile.play("pressed")

func _on_smile_button_button_up():
	$Smile.play("default")
	game_over = false
	new_game.emit()

func _on_new_game_button_pressed():
	new_game.emit()
	$SettingsConfig.hide()

'''
HANDLE MODE
'''
func _on_mode_button_button_down():
	var flag_mode = get_parent().flag_mode
	if flag_mode:
		$Mode.play("flag_pressed")
	else:
		$Mode.play("bomb_pressed")

func _on_mode_button_button_up():
	var flag_mode = get_parent().flag_mode
	if flag_mode:
		$Mode.play("bomb")
	else:
		$Mode.play("flag")
	get_parent().flag_mode = not get_parent().flag_mode

'''
HANDLE SETTINGS
'''
func _on_settings_button_button_down():
	$Settings.play("pressed")

func _on_settings_button_button_up():
	$Settings.play("default")
	showing_settings()
	
func showing_settings(show=true):
	if show:
		$SettingsConfig.show()
		get_parent().disable_tiles()
	else:
		$SettingsConfig.hide()
		get_parent().disable_tiles(false)

'''
HANDLE TIMER
'''
func _on_timer_timeout():
	passed_time += 1
	var minutes = str(int(passed_time / 60))
	var seconds = str(passed_time % 60)
	var text
	if minutes.length() == 1:
		if seconds.length() == 1:
			text = "0" + minutes + ":" + "0" + seconds
		else:
			text = "0" + minutes + ":" + seconds
	else:
		if seconds.length() == 1:
			text = minutes + ":" + "0" + seconds
		else:
			text = minutes + ":" + seconds
	$Time/Message.text = text

func reset_timer():
	$Timer.start()
	passed_time = 0
	$Time/Message.text = "00:00"
	
