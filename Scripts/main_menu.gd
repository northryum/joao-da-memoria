extends Control

# Pegamos as referências dos nossos blocos de interface
@onready var main_page = $MainPage
@onready var setup_page = $SetupPage
@onready var options_page = $OptionsPage
@onready var setup_page_multiplayer = $SetupPage_multiplayer
@onready var spin_linhas = $SetupPage/Linhas
@onready var spin_colunas = $SetupPage/Colunas

func _ready():
	# Ao iniciar o jogo, garantimos que apenas a página principal apareça
	show_page(main_page)

#region main page
func show_page(page_to_show):
	# 1. Esconde todas as páginas
	main_page.hide()
	setup_page.hide()
	options_page.hide()
	setup_page_multiplayer.hide()
	
	# 2. Mostra apenas a página que passamos como parâmetro
	page_to_show.show()

func _on_iniciar_partida_pressed() -> void:
	# Extrai os números exatos da propriedade "value" dos nós SpinBox
	var qtd_linhas = spin_linhas.value
	var qtd_colunas = spin_colunas.value

	# Salva os números no nosso script global
	GameManager.linhas_atuais = qtd_linhas
	GameManager.colunas_atuais = qtd_colunas

	# Muda para a cena do jogo (confirme se o caminho do seu board.tscn está correto)
	get_tree().change_scene_to_file("res://Cenas/board.tscn")
	# O comando print exibe o texto no painel "Output" (Saída) na parte inferior do editor
	print("Vamos criar um tabuleiro com ", qtd_linhas, " linhas e ", qtd_colunas, " colunas!")

func _on_novo_jogo_pressed() -> void:
	# Oculta as outras e mostra a página de configuração do jogo
	show_page(setup_page)


func _on_multiplayer_pressed() -> void:
	show_page(setup_page_multiplayer)


func _on_opções_pressed() -> void:
	show_page(options_page)


func _on_sair_pressed() -> void:
	get_tree().quit()
	pass
	
#endregion 

func _on_voltar_pressed() -> void:
	show_page(main_page)
	pass # Replace with function body.


#region SetupPage_multiplayer




#endregion 

#region OptionsPage


func _on_som_pressed() -> void:
	pass # Replace with function body.


func _on_tela_pressed() -> void:
	pass # Replace with function body.


func _on_idioma_pressed() -> void:
	pass # Replace with function body.

#endregion 
