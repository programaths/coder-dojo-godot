extends Node2D

var match_found = 0

var first_card = null
var second_card = null

func _ready():
	start_game()

func start_game():
	randomize()
	var cards = get_tree().get_nodes_in_group("card")
	cards.shuffle()
	for i in range(0,9):
		cards[i].suite = randi()%4
		cards[i].value = i
		cards[i+9].suite=cards[i].suite
		cards[i+9].value=cards[i].value
		cards[i].connect("clicked",self,"card_clicked")
		cards[i+9].connect("clicked",self,"card_clicked")
		cards[i].unlock()
		cards[i+9].unlock()

func card_clicked(card):
	if second_card != null: return
	if first_card == null:
		first_card = card
		card.lock()
		card.reveal()
		yield(card,"revealed")
	else:
		second_card = card
		card.lock()
		card.reveal()
		yield(card,"revealed")
		if first_card.same(second_card):
			match_found = match_found + 1
			first_card.hide()
			second_card.hide()
			first_card = null
			second_card = null
		else:
			yield(get_tree().create_timer(2),"timeout")
			first_card.conceal()
			second_card.conceal()
			yield(second_card,"concealed")
			first_card.unlock()
			second_card.unlock()
			first_card = null
			second_card = null
			