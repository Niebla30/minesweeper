extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func initialize_borders(rows, columns):
	$bottom.position.y += (rows-1)*40
	for i in range(columns):
		var new_child_top = $top.duplicate()
		var new_child_bottom = $bottom.duplicate()
		new_child_top.position.x += i*40
		new_child_bottom.position.x += i*40
		add_child(new_child_top)
		add_child(new_child_bottom)
	$topright.position.x += (columns-1)*40
	$right.position.x += (columns-1)*40
	for j in range(rows):
		var new_child_left = $left.duplicate()
		var new_child_right = $right.duplicate()
		new_child_left.position.y += j*40
		new_child_right.position.y += j*40
		add_child(new_child_left)
		add_child(new_child_right)
	$bottomleft.position.y += (rows-1)*40
	
	$bottomright.position += Vector2((columns-1)*40, (rows-1)*40)
