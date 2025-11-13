extends AnimatedSprite2D

@export var number = 1
#var mode = "normal" # or "flag"
var flagged = false
var revealed = false
var adyacents_revealed = false
var i = 0
var j = 0

func _ready():
	play("default")

func set_number(n):
	number = n

func _on_button_pressed():
	var mode = get_parent().flag_mode
	reveal(mode)

func disable(disabled = true): #if false, ables tile
	$Button.disabled = disabled
	
func reveal(flag_mode):
	if not revealed: # primera vez que pulsas
		if not flag_mode and not flagged:
			revealed = true
			if number == -1:
				play("died")
				get_parent().on_game_over()
			elif number == 0:
				play("n0")
				get_parent().reveal_adyacents(self)
			else:
				play("n"+str(number))
		elif flag_mode:
			if flagged:
				play("default")
				flagged = false
				get_parent().actualize_bombs_left(-1)
			else:
				play("flag")
				flagged = true
				get_parent().actualize_bombs_left(1)
				
	elif not adyacents_revealed:
		if get_parent().is_safe(self):
			adyacents_revealed = true
			get_parent().reveal_adyacents(self)
			

func _on_button_button_down():
	if revealed and not adyacents_revealed and not get_parent().is_safe(self):
		get_parent().highlight_adyacents(self)
		
func _on_button_button_up():
	if revealed and not adyacents_revealed and not get_parent().is_safe(self):
		get_parent().unhighlight_adyacents(self)
