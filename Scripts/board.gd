extends Control

# Variáveis do Tabuleiro
@export var card_scene: PackedScene
@export var spritesheet: Texture2D # Arraste a imagem dos animais para cá no Inspector

# Variáveis de Interface e Tempo
@onready var timer_label = $UI/TimerLabel
@onready var pause_menu = $UI/PauseMenu
# 2. LAYOUT: Atualizamos o caminho para o GridContainer dentro do MarginContainer
@onready var grid = $MarginContainer/GridContainer

# Configurações do Jogo
var colunas_na_imagem = 5
var linhas_na_imagem = 6
var tempo_decorrido: float = 0.0
var jogo_pausado: bool = false
var pode_clicar = true # Impede o clique enquanto o juiz avalia

# Variáveis do Juiz
var carta_1 = null
var carta_2 = null

func _ready():
	var total_cartas = GameManager.linhas_atuais * GameManager.colunas_atuais
	
	# Se o número for ímpar, removemos uma carta para não travar
	if total_cartas % 2 != 0:
		print("Aviso: Tabuleiro ímpar! Removendo uma unidade para manter os pares.")
		total_cartas -= 1 
		
	grid.columns = GameManager.colunas_atuais
	var todas_as_imagens = _extrair_texturas()
	_generate_board(total_cartas, todas_as_imagens)

func _extrair_texturas() -> Array:
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

func _generate_board(total, imagens_recortadas):
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
	carta._turn_face_up()
		
	if carta_1 == null:
		carta_1 = carta
	elif carta_2 == null:
		carta_2 = carta
		# Trava a mesa no exato milissegundo do segundo clique!
		pode_clicar = false 
		_checar_par()

func _checar_par():
	await get_tree().create_timer(1.0).timeout
	
	if carta_1.front_texture == carta_2.front_texture:
		carta_1._set_matched()
		carta_2._set_matched()
	else:
		carta_1._turn_face_down() # Usando o novo nome da função
		carta_2._turn_face_down()
		
	carta_1 = null
	carta_2 = null
	pode_clicar = true

func _process(delta):
	# Se o jogo não estiver pausado, o tempo corre
	if not jogo_pausado:
		tempo_decorrido += delta
		atualizar_texto_timer()

func atualizar_texto_timer():
	# Converte os segundos corridos para Minutos e Segundos
	#var tempo_total_segundos = int(tempo_decorrido)
	var minutos = int(tempo_decorrido) / 60
	var segundos = int(tempo_decorrido) % 60
	var milissegundos = int((tempo_decorrido - int(tempo_decorrido)) * 1000) # x - tempo_total_segundos
	# Formata o texto para ficar bonito (ex: 01:05)
	timer_label.text = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2) + ":" + str(milissegundos).pad_zeros(3)
	
func _input(event):
	# "ui_cancel" é a tecla ESC por padrão na Godot
	if event.is_action_pressed("ui_cancel"):
		alternar_pausa()

func alternar_pausa():
	jogo_pausado = !jogo_pausado
	get_tree().paused = jogo_pausado # Congela ou descongela o motor da Godot
	
	if jogo_pausado:
		pause_menu.show()
	else:
		pause_menu.hide()

#region botoes
func _on_continuar_pressed() -> void:
	alternar_pausa()

func _on_opções_pressed() -> void:
	print("Menu de opções será aberto aqui em breve!")
	# Por enquanto vamos deixar vazio

func _on_sair_pressed() -> void:
	# MUITO IMPORTANTE: Tira o pause antes de sair, senão o Menu Principal nasce congelado!
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Cenas/main_menu.tscn")

func _on_reiniciar_pressed() -> void:
	get_tree().paused = false
	
	# Recarrega a cena do tabuleiro (que deve ser a mesma onde estamos)
	# Confirme se o caminho "res://board.tscn" está correto no seu projeto.
	get_tree().reload_current_scene()

#endregion
