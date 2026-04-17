extends Control

@export var card_scene: PackedScene
@export var spritesheet: Texture2D # Arraste a imagem dos animais para cá no Inspector

@onready var grid = $CenterContainer/GridContainer

# Configurações da Spritesheet (Animais)
var colunas_na_imagem = 5
var linhas_na_imagem = 6

func _ready():
	grid.columns = GameManager.colunas_atuais
	var total_cartas = GameManager.linhas_atuais * GameManager.colunas_atuais
	
	# Criamos uma lista com todas as imagens recortadas
	var todas_as_imagens = extrair_texturas()
	
	# Embaralhamos e geramos o tabuleiro (veremos isso a seguir)
	generate_board(total_cartas, todas_as_imagens)

func extrair_texturas() -> Array:
	var lista_de_recortes = []
	
	# Descobrimos o tamanho de cada "janela" dividindo o tamanho total
	var largura_frame = spritesheet.get_width() / colunas_na_imagem
	var altura_frame = spritesheet.get_height() / linhas_na_imagem
	
	# Percorremos cada linha e cada coluna para criar o Rect2
	for y in range(linhas_na_imagem):
		for x in range(colunas_na_imagem):
			# Criamos o objeto de recorte
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = spritesheet
			
			# Definimos a região: Rect2(X, Y, Largura, Altura)
			atlas_texture.region = Rect2(x * largura_frame+2, y * altura_frame, largura_frame, altura_frame)
			
			lista_de_recortes.append(atlas_texture)
			
	return lista_de_recortes

func generate_board(total, imagens_recortadas):
	# 1. Pegamos apenas a quantidade de imagens necessária para formar os pares
	# Se o total de cartas é 12, precisamos de 6 imagens únicas
	var quantidade_pares = total / 2
	
	# Embaralhamos a lista de todos os 30 animais para pegar animais aleatórios a cada jogo
	imagens_recortadas.shuffle()
	
	var imagens_da_partida = []
	
	for i in range(quantidade_pares):
		var img = imagens_recortadas[i]
		imagens_da_partida.append(img) # Adiciona a primeira do par
		imagens_da_partida.append(img) # Adiciona a segunda do par (duplicata)
	
	# 2. Agora embaralhamos as cartas que já estão em pares
	imagens_da_partida.shuffle()
	
	# 3. Criamos as cartas e entregamos as fotos recortadas
	for i in range(total):
		var new_card = card_scene.instantiate()
		grid.add_child(new_card)
		
		# Aqui está a "cola": entregamos a imagem recortada para a variável da carta
		new_card.front_texture = imagens_da_partida[i]
