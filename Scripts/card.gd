extends TextureButton

# O '@export' permite escolher a imagem da frente da carta diretamente no Inspector
@export var front_texture: Texture2D
var back_texture: Texture2D
var is_flipped: bool = false

func _ready():
	# Salva a imagem do verso (definida no Inspector) para usar depois
	back_texture = texture_normal
	# Conecta automaticamente o clique do botão à nossa função
	pressed.connect(_on_pressed)

func _on_pressed():
	# Desativa o botão temporariamente para evitar cliques duplos durante a animação
	disabled = true
	flip_animation()

func flip_animation():
	var tween = create_tween()
	 
	# 1º Passo: Encolhe a carta no eixo X (largura fica 0)
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	 
	# 2º Passo: Troca a imagem exatamente quando a largura é 0 (invisível)
	tween.tween_callback(swap_texture)
	 
	# 3º Passo: Expande a carta de volta ao tamanho normal (largura 1)
	tween.tween_property(self, "scale:x", 1.0, 0.15)
	
	# 4º Passo: Reativa o botão para poder ser clicado novamente
	tween.tween_callback(func(): disabled = false)
	
func swap_texture():
	# Inverte o estado lógico da carta
	is_flipped = !is_flipped
	
	# Define qual imagem deve aparecer
	if is_flipped:
		texture_normal = front_texture
	else:
		texture_normal = back_texture
	
