extends Node2D

@export var Tile: PackedScene
var rows = 10 # min 5
var columns = 10 # min 10
var ideal_number_of_bombs = (rows * columns) / 5
var mode = "normal" # borrar?
var flag_mode = false
var tileset = []
var number_of_bombs = ideal_number_of_bombs
var bombs = []
var flags = 0

func _ready():
	$borders.initialize_borders(rows, columns)
	$HUD.position_buttons(columns)
	new_game()
	
func _on_hud_new_game():
	new_game()

'''
HANDLE NEW GAME
'''
func new_game():
	free_tiles()
	bombs = randomize_bombs(number_of_bombs)
	for i in range(columns):
		tileset.append([])
		for j in range(rows):
			var new_tile = Tile.instantiate()
			new_tile.position.x = 44+i*40
			new_tile.position.y = 134+j*40
			new_tile.i = i
			new_tile.j = j
			set_number(new_tile)
			add_child(new_tile)
			tileset[i].append(new_tile)
	flags = 0
	actualize_bombs_left(0)
	$HUD.reset_timer()

''' HANDLE GAME OVER '''
func on_game_over():
	disable_tiles()
	$HUD.died()

''' HANDLE WINNING '''
func _on_hud_maybe_won():
	print("checking!")
	var won = true
	# Se que tengo tantas flags como bombas
	# si todas las flags son bombas
	# es que he ganado
	for row in tileset:
		for tile in row:
			if tile.flagged and not tile.number==-1:
				won = false
				#break?
	if won:
		print("won!")
		on_won()
	
func on_won():
	print("entered won")
	for row in tileset:
		for tile in row:
			if tile.flagged:
				tile.play("bomb")
			elif not tile.revealed:
				tile.reveal(false)
				
''' HANDLE BOMMBS LEFT '''
func actualize_bombs_left(add): #add = 1, -1, 0
		flags += add
		$HUD.set_number_of_bombs(number_of_bombs - flags)

'''
FUNCTIONS THAT WORK WITH ALL TILES
'''
func free_tiles():
	for row in tileset:
		for tile in row:
			tile.queue_free()
	tileset = []

func disable_tiles(disable = true): # if false, ables all tiles
	for row in tileset:
		for tile in row:
			tile.disable(disable)

''' RANDOMIZE BOMBS '''
func randomize_bombs(number_of_bombs=ideal_number_of_bombs):
	var bomb_indexes = []
	for b in range(number_of_bombs):
		var i = randi_range(0, columns-1)
		var j = randi_range(0, rows-1)
		while [i, j] in bomb_indexes:
			i = randi_range(0, columns-1)
			j = randi_range(0, rows-1)
		bomb_indexes.append([i, j])
	return bomb_indexes

'''
SETTING NUMBERS TO TILES
'''
func set_number(tile):
	var place = [tile.i, tile.j]
	if place in bombs:
		tile.set_number(-1)
	else:
		tile.set_number(count_bombs(tile.i, tile.j))

# Counts bombs adyacent to a certain position (neccessary for initialization of tiles)
func count_bombs(i, j):
	var ady_bombs = 0
	for k in [i-1, i, i+1]:
		for l in [j-1, j, j+1]:
			if [k, l] in bombs:
				ady_bombs += 1
	return ady_bombs
				
'''
CHANGING MODE WITH BUTTON
'''
func _on_mode_pressed():
	if flag_mode:
		$Mode/AnimatedSprite2D.play("bomb")
		flag_mode = false
	else:
		$Mode/AnimatedSprite2D.play("flag")
		flag_mode = true
		
'''
HANDLE REVEALING ADYACENTS
'''
func reveal_adyacents(tile):
	var adyacent_indexes = get_adyacent_indexes(tile.i, tile.j)
	for index in adyacent_indexes:
		var ady_tile = tileset[index[0]][index[1]]
		if not ady_tile.revealed:
			ady_tile.reveal(false)
			
func highlight_adyacents(tile):
	var adyacent_indexes = get_adyacent_indexes(tile.i, tile.j)
	for index in adyacent_indexes:
		var ady_tile = tileset[index[0]][index[1]]
		if not ady_tile.revealed and not ady_tile.flagged:
				ady_tile.play("n0")
				
func unhighlight_adyacents(tile):
	var adyacent_indexes = get_adyacent_indexes(tile.i, tile.j)
	for index in adyacent_indexes:
		var ady_tile = tileset[index[0]][index[1]]
		if not ady_tile.revealed and not ady_tile.flagged:
				ady_tile.play("default")
					
func get_adyacent_indexes(i, j):
	var adyacent_indexes = []
	for k in [i-1, i, i+1]:
		for l in [j-1, j, j+1]:
			var c1 = k >= 0 and k < columns
			var c2 = l >= 0 and l < rows
			if c1 and c2:
				adyacent_indexes.append([k, l])
	return adyacent_indexes
	
func is_safe(tile):
	var adyacent_indexes = get_adyacent_indexes(tile.i, tile.j)
	var flags = 0
	for index in adyacent_indexes:
		if tileset[index[0]][index[1]].flagged:
			flags += 1
	return flags >= tile.number

'''
TESTER FUNCTIONS
'''
func _on_button_pressed():
	for row in tileset:
		for tile in row:
			tile.reveal(false)






