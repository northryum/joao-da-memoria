extends Control

@export var card_scene: PackedScene
@onready var grid = $GridContainer

func _ready():
	
	# 1. Ajusta o GridContainer para ter o número de colunas escolhido no menu
	grid.columns = GameManager.colunas_atuais
	
	# 2. Calcula o total de cartas multiplicando linhas por colunas
	var total_cards = GameManager.linhas_atuais * GameManager.colunas_atuais
	
	# 3. Manda gerar o tabuleiro com esse total
	generate_board(total_cards)

func generate_board(total):
	for i in range(total):
		var new_card = card_scene.instantiate()
		grid.add_child(new_card)
