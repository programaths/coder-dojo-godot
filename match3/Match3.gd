extends Node2D

var packed_tile = preload("res://match3/Tile.tscn")

var first:Match3Tile = null

func _ready():
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.connect("selected",self,"tile_clicked")
#		tile.connect("move_done",self,"tile_move_done")
		
func tile_clicked(tile:Match3Tile):
	if first == null:
		first = tile
		return
	if first==tile:
		first = null
		return
	if tile != first.left_tile and tile != first.right_tile and tile != first.up_tile and tile != first.down_tile:
		first = null
		return
	first.move_to(tile.position,true)
	tile.move_to(first.position,true)
	yield(tile,"move_done")
	yield(get_tree().create_timer(0.2),"timeout")
	tile_swapped(first,tile)
	first = null
	
func inspect_tile(first):
	var nb_left = []
	var nb_right = []
	var nb_up = []
	var nb_down = []
	var remove = false
	if first.left_tile!=null:
		nb_left = first.left_tile.get_same_tiles(Match3Tile.DIRECTION.LEFT,first.color,first.shape)
	if first.right_tile!=null:
		nb_right = first.right_tile.get_same_tiles(Match3Tile.DIRECTION.RIGHT,first.color,first.shape)
	if first.up_tile!=null:
		nb_up = first.up_tile.get_same_tiles(Match3Tile.DIRECTION.UP,first.color,first.shape)
	if first.down_tile!=null:
		nb_down = first.down_tile.get_same_tiles(Match3Tile.DIRECTION.DOWN,first.color,first.shape)
	if nb_left.size()+nb_right.size()>1:
		remove = true
		for t in nb_left:
			t.to_remove = true
		for t in nb_right:
			t.to_remove = true
	if nb_up.size()+nb_down.size()>1:
		remove = true
		for t in nb_up:
			t.to_remove = true
		for t in nb_down:
			t.to_remove = true
	return remove
			
func inspect_all():
	var tiles_to_remove=[]
	for bot in get_tree().get_nodes_in_group("bottoms"):
		var tile = bot.tile
		while tile!=null:
			if inspect_tile(tile):
				tiles_to_remove.append(tile)
			tile=tile.up_tile
	for bot in get_tree().get_nodes_in_group("bottoms"):
		var t = bot.tile
		var u = bot.tile
		while u!=null and t!=null:
			while u.up_tile!=null && !u.to_remove:
				u=u.up_tile
			if u==null: break
			t=u
			while t and t.to_remove:
				t=t.up_tile
			if t==null: break
			while u!=null and t!=null and !t.to_remove:
				t.move_to(u.position,false)
				t=t.up_tile
				u=u.up_tile
	for t in tiles_to_remove:
		t.queue_free()
	return !tiles_to_remove.empty()

func tile_swapped(_first,_second):
	var cont = true
	while cont:
		cont = inspect_all()
		yield(get_tree().create_timer(0.5),"timeout")
	cont = true
	while cont:
		for bot in get_tree().get_nodes_in_group("bottoms"):
			var missing = 5
			var tile = bot.tile
			while tile!=null:
				missing = missing-1
				tile = tile.up_tile
			for i in range(missing):
				var new_tile = packed_tile.instance()
				add_child(new_tile)
				new_tile.position.x = bot.position.x
				new_tile.position.y = bot.position.y -(4-i)*96
				new_tile.connect("selected",self,"tile_clicked")
		yield(get_tree().create_timer(0.5),"timeout")
		cont = inspect_all()
		yield(get_tree().create_timer(0.5),"timeout")