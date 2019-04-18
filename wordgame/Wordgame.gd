extends Node

onready var word_list:ItemList = $PanelContainer/ItemList

onready var board = $Board

var path = []

func _ready():
	for tile in get_tree().get_nodes_in_group("tiles"):
		tile.connect("clicked",self,"tile_clicked")
		tile.connect("released",self,"tile_released")
		tile.connect("hover_pressed",self,"tile_hover_pressed")

func tile_clicked(target):
	path.clear()
	path.append(target)

func tile_released(target):
	if check_word(get_word()):
		pass
	path.clear()
	board.clear_path()

func tile_hover_pressed(target):
	path.append(target)
	if path.size()>1:
		board.draw_path(path)

func get_word():
	if path.empty():
		return ""
	var word = ""
	for tile in path:
		word = word + tile.letter
	return word

func check_word(word):
	var i = word_list.get_item_count() - 1
	var removed = false
	while i>-1:
		if word_list.get_item_text(i)==word:
			word_list.remove_item(i)
			removed = true
		i = i-1
	return removed