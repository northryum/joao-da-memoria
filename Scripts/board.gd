extends Control

@export var card_scene: PackedScene
@export var spritesheet: Texture2D # Arraste a imagem dos animais para cá no Inspector

@onready var grid = $CenterContainer/GridContainer

# Configurações da Spritesheet (Animais)
var colunas_na_imagem = 5
var linhas_na_imagem = 6
# Variáveis do Juiz
var carta_1 = null
var carta_2 = null
var pode_clicar = true # Evita que o jogador clique numa terceira carta enquanto o juiz avalia

func _ready():
	var total_cartas = GameManager.linhas_atuais * GameManager.colunas_atuais
	
	# Se o número for ímpar, removemos uma carta para não travar
	if total_cartas % 2 != 0:
		print("Aviso: Tabuleiro ímpar! Removendo uma unidade para manter os pares.")
		total_cartas -= 1 
		
	grid.columns = GameManager.colunas_atuais
	var todas_as_imagens = extrair_texturas()
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
			atlas_texture.region = Rect2(x * largura_frame+1, y * altura_frame, largura_frame, altura_frame)
			
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
	# Criamos as cartas e entregamos as fotos recortadas
	for i in range(total):
		var new_card = card_scene.instantiate()
		grid.add_child(new_card)
		new_card.front_texture = imagens_da_partida[i]
		
		# NOVA LINHA: Conecta o sinal da carta à função do juiz
		# Troque .flipped por .clicked
		new_card.clicked.connect(_on_carta_clicada)

func _on_carta_clicada(carta):
	# O juiz barra o clique instantaneamente se já estiver avaliando duas cartas
	if not pode_clicar:
		return
		
	# Se passou pela barreira, o juiz manda a carta virar
	carta.turn_face_up()
		
	if carta_1 == null:
		carta_1 = carta
	elif carta_2 == null:
		carta_2 = carta
		# Trava a mesa no exato milissegundo do segundo clique!
		pode_clicar = false 
		checar_par()

func checar_par():
	await get_tree().create_timer(1.0).timeout
	
	if carta_1.front_texture == carta_2.front_texture:
		carta_1.set_matched()
		carta_2.set_matched()
	else:
		carta_1.turn_face_down() # Usando o novo nome da função
		carta_2.turn_face_down()
		
	carta_1 = null
	carta_2 = null
	pode_clicar = true
