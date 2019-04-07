extends Node2D

var board = Quadromino.new()

onready var ap = $AnimatedSprite
onready var display_board = $BoardOffset
onready var tween = $Tween


var monomino = preload("res://quadromino/Monomino.tscn")
var quadromino = preload("res://quadromino/QuadrominoPiece.tscn")


var current_piece:Node2D

func _ready():
	board.connect("current_piece_moved",self,"piece_moved")
	board.connect("current_piece_rotated",self,"piece_rotated")
	board.connect("next_piece_changed",self,"next_piece_changed")
	board.connect("current_piece_changed",self,"current_piece_changed")
	board.connect("current_piece_frozen",self,"current_piece_frozen")
	board.connect("removed_lines",self,"removed_lines")
	
	board.start(self)
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("rotate_left"):
		board.rotate_left()
	if Input.is_action_just_pressed("rotate_right"):
		board.rotate_right()
	if Input.is_action_just_pressed("ui_right"):
		board.move_right()
	if Input.is_action_just_pressed("ui_left"):
		board.move_left()
	if Input.is_action_just_pressed("ui_down"):
		board.do_game_round()
	update()
	
func _draw():
	board.draw(self)
	
func piece_moved(p,n):
	tween.interpolate_property(current_piece,"position",current_piece.position,n*24,0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	
	
func piece_rotated(p_o,n_o):
	tween.interpolate_property(current_piece,"child_rotation",p_o*90,n_o*90,0.4,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	
	
func next_piece_changed(p):
	ap.play(p.t)
	
func current_piece_changed(p):
	current_piece = quadromino.instance()
	current_piece.add_to_group("pieces")
	current_piece.set_type(p.t)
	display_board.add_child(current_piece)
	
	
func current_piece_frozen(n_p,n_o):
	tween.stop_all()
	current_piece.position = n_p*24
	print(current_piece.position)
	current_piece.child_rotation = n_o*90
	current_piece.modulate = Color.white.darkened(0.5)
	
func removed_lines(lines:Array):
	if lines.empty(): return
	var pieces = get_tree().get_nodes_in_group("pieces")
	var monominoes = get_tree().get_nodes_in_group("monominoes")
	for piece in pieces:
		var nb_smaller = 0
		for line in lines:
			print(line,"-",piece.position.y/24)
			if line>=piece.position.y/24-1:
				nb_smaller = nb_smaller + 1
			if piece.position.y/24 == line:
				piece.queue_free()
		if nb_smaller>0:
			if piece is QuadrominoPiece:
				var ori = int(piece.child_rotation/90)
				var piece_map=board.get_piece_map(piece.get_type(),ori)
				for i in range(piece_map.size()):
					for j in range(piece_map[i].size()):
						if piece_map[i][j]==1:
							if piece.position.y/24+i<=22:
								var new_monomino = monomino.instance()
								display_board.add_child(new_monomino)
								new_monomino.add_to_group("monominoes")
								new_monomino.add_to_group("pieces")
								new_monomino.modulate = board.get_draw_color(piece.get_type())
								new_monomino.position = piece.position + Vector2(24*j,24*(i+nb_smaller)) 
				piece.queue_free()
			else:
				piece.position.y = piece.position.y +24*(nb_smaller)
	for a_monomino in get_tree().get_nodes_in_group("monominoes"):
		if (a_monomino.position.y)/24>22 or board.get_piece_type_at((a_monomino.position.y)/24,a_monomino.position.x/24)=="":
			a_monomino.queue_free()



class Quadromino:
	signal next_piece_changed(piece)
	signal current_piece_changed(piece)
	signal current_piece_rotated(old_orientation,new_orientation)
	signal current_piece_rotated_refused()
	signal current_piece_moved(old_position,new_position)
	signal current_piece_moved_refused()
	signal current_piece_frozen(new_position,new_orientation)
	signal removed_lines(lines)

	var timer
	var board = []
	const I = {"t":"I","v": [[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]]}
	const J = {"t":"J","v": [[1,0,0],[1,1,1],[0,0,0]]}
	const L = {"t":"L","v": [[0,0,1],[1,1,1],[0,0,0]]}
	const O = {"t":"O","v": [[0,0,0,0],[0,1,1,0],[0,1,1,0],[0,0,0,0]]}
	const S = {"t":"S","v": [[0,1,1],[1,1,0],[0,0,0]]}
	const T = {"t":"T","v": [[0,1,0],[1,1,1],[0,0,0]]}
	const Z = {"t":"Z","v": [[1,1,0],[0,1,1],[0,0,0]]}
	var pieces = [I,J,L,O,S,T,Z]
	var piece_maps = {
		"I" : I,
		"J" : J,
		"L" : L,
		"O" : O,
		"S" : S,
		"T" : T,
		"Z" : Z
	}
	var bag = []
	var current_piece
	var current_piece_position = Vector2(0,0)
	var current_piece_orientation = 0
	var next_piece
	
	func get_piece_map(type,orientation):
		var piece = clone_piece(piece_maps[type])
		if orientation>0:
			for i in range(orientation%4):
				rotated_right(piece)
		if orientation<0:
			orientation = (4-(-orientation)%4)%4
			for i in range(orientation):
				rotated_right(piece)
		return piece.v
		
	func get_piece_type_at(line,cell):
		if line>21: return ""
		return board[line][cell]
	
	func start(node:Node2D):
		for i in range(22):
			var board_line = []
			for i in range(10):
				board_line.append("")
			board.append(board_line)
		fill_bag()
		current_piece = bag.pop_front()
		next_piece = bag.pop_front()
		timer = Timer.new()
		timer.one_shot = true
		timer.start(0.25)
		timer.connect("timeout",self,"do_game_round")
		node.add_child(timer)
		emit_signal("current_piece_changed",current_piece)
		emit_signal("next_piece_changed",next_piece)
		
		
	func do_game_round():
		print("doing round")
		var previous_position = current_piece_position
		current_piece_position.y=current_piece_position.y+1
		if current_piece_collides():
			current_piece_position.y=current_piece_position.y-1
			var ps = get_piece_dimensions(current_piece.t)
			for i in range(ps.h):
				for j in range(ps.w):
					if current_piece.v[i][j]==1:
						board[i+current_piece_position.y][j+current_piece_position.x]=current_piece.t
			emit_signal("current_piece_frozen",current_piece_position,current_piece_orientation)
			compact_board()
			get_next_piece()
			timer.start(0.25)
		else:
			emit_signal("current_piece_moved",previous_position,current_piece_position)
			timer.start(0.25)
			
	func line_occupancy(line):
		var nb_filled = 0
		for cell in line:
			if cell!="":
				nb_filled = nb_filled+1
		return nb_filled
	
	func compact_board():
		var move_to = board.size()-1
		var gap = 0
		var line_index = board.size() - 1
		var removed_lines = []
		while line_index>=0:
			while line_index - gap > 0 and line_occupancy(board[line_index-gap])>9:
				removed_lines.append(line_index-gap)
				gap = gap + 1
			if line_index - gap < 0: break
			for i in range(board[line_index-gap].size()):
				board[line_index][i]=board[line_index-gap][i]
			line_index = line_index - 1
		emit_signal("removed_lines",removed_lines)
		
	func fill_bag():
		pieces.shuffle()
		for piece in pieces:
			# We don't want to modify prototype pieces
			bag.append(clone_piece(piece))
			
	func get_next_piece():
		if bag.empty():
			fill_bag()
		current_piece = next_piece
		next_piece = bag.pop_front()
		current_piece_position = Vector2(0,0)
		current_piece_orientation = 0
		emit_signal("current_piece_changed",current_piece)
		emit_signal("next_piece_changed",next_piece)
		
		
	func get_piece_dimensions(p):
		match p:
			"I","O": return {"w":4,"h":4}
			"J","L","S","T","Z": return {"w":3,"h":3}
		
	func rotated_left(piece):
		if piece.t == "O": return
		var ps = get_piece_dimensions(piece.t)
		current_piece_orientation = current_piece_orientation - 1
		for i in range(ps.h/2):
			for j in range((ps.w-1)/2+1):
				var tmp = piece.v[i][j]
				piece.v[i][j] = piece.v[j][ps.w-1-i]
				piece.v[j][ps.w-1-i] = piece.v[ps.h-1-i][ps.w-1-j]
				piece.v[ps.h-1-i][ps.w-1-j] = piece.v[ps.h-1-j][i]
				piece.v[ps.h-1-j][i] = tmp
				
	func rotated_right(piece):
		if piece.t == "O": return
		var ps = get_piece_dimensions(piece.t)
		current_piece_orientation = current_piece_orientation + 1
		for i in range(ps.h/2):
			for j in range((ps.w-1)/2+1):
				var tmp = piece.v[ps.h-1-j][i]
				piece.v[ps.h-1-j][i] = piece.v[ps.h-1-i][ps.w-1-j]
				piece.v[ps.h-1-i][ps.w-1-j] = piece.v[j][ps.w-1-i]
				piece.v[j][ps.w-1-i] = piece.v[i][j]
				piece.v[i][j] = tmp
				
	func rotate_right():
		var previous_orientation = current_piece_orientation
		rotated_right(current_piece)
		if current_piece_collides():
			rotated_left(current_piece)
			emit_signal("current_piece_rotated_refused")
		else:
			emit_signal("current_piece_rotated",previous_orientation,current_piece_orientation)
		
	
	func rotate_left():
		var previous_orientation = current_piece_orientation
		rotated_left(current_piece)
		if current_piece_collides():
			rotated_right(current_piece)
			emit_signal("current_piece_rotated_refused")
		else:
			emit_signal("current_piece_rotated",previous_orientation,current_piece_orientation)
		
	func current_piece_collides():
		var ps = get_piece_dimensions(current_piece.t)
		for i in range(ps.h):
			for j in range(ps.w):
				if current_piece_position.x+j<0:
					if current_piece.v[i][j]==1:
						return true
				if current_piece_position.x+j>9:
					if current_piece.v[i][j]==1:
						return true
				if current_piece_position.y+i>21:
					if current_piece.v[i][j]==1:
						return true
				if current_piece_position.y+i<22 && current_piece_position.x+j>=0 && current_piece_position.x+j<10 && current_piece.v[i][j]==1 && board[current_piece_position.y+i][current_piece_position.x+j]!="":
					return true
		return false
	
	func clone_piece(piece):
		var new_v = []
		for piece_line in piece.v:
			var new_v_line = []
			for piece_column in piece_line:
				new_v_line.append(piece_column)
			new_v.append(new_v_line)
		return {"t":piece.t,"v":new_v}
		
	func move_right():
		var previous_position = current_piece_position
		current_piece_position.x = current_piece_position.x + 1
		if current_piece_collides():
			current_piece_position.x = current_piece_position.x - 1
			emit_signal("current_piece_moved_refused")
		else:
			emit_signal("current_piece_moved",previous_position,current_piece_position)
		
	func move_left():
		var previous_position = current_piece_position
		current_piece_position.x = current_piece_position.x - 1
		if current_piece_collides():
			current_piece_position.x = current_piece_position.x + 1
			emit_signal("current_piece_moved_refused")
		else:
			emit_signal("current_piece_moved",previous_position,current_piece_position)
	
	func get_draw_color(p):
		match p:
			"I": return Color.cyan
			"O": return Color.yellow
			"T" : return Color.purple
			"S" : return Color.green
			"Z" : return Color.red
			"J" : return Color.blue
			"L" : return Color.orange
		return Color.black
				
	func draw(node:Node2D):
		node.draw_set_transform(Vector2(48,48),0,Vector2(1,1))
		node.draw_rect(Rect2(Vector2(0,0),Vector2(240,480)),Color.black)
		node.draw_rect(Rect2(Vector2(0,0),Vector2(240,480)),Color.black,false)
		for i in range(22):
			for j in range(10):
				node.draw_rect(Rect2(Vector2(j*24,i*24),Vector2(24,24)),get_draw_color(board[i][j]))
		if current_piece == null: return
		var ps = get_piece_dimensions(current_piece.t)
		for i in range(ps.h):
			for j in range(ps.w):
				if current_piece.v[i][j] == 1:
					node.draw_circle(Vector2(j*24+12+24*current_piece_position.x,i*24+12+24*current_piece_position.y),12,get_draw_color(current_piece.t))