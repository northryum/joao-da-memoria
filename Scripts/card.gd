extends TextureButton

# Mudamos o nome do sinal. Agora ela avisa no momento exato do clique!
signal clicked(card_node)

@export var front_texture: Texture2D
var back_texture: Texture2D
var is_flipped: bool = false
var is_matched: bool = false

func _ready():
	back_texture = texture_normal
	pressed.connect(_on_pressed)

func _on_pressed():
	if is_flipped or is_matched:
		return
	
	# A carta NÃO vira mais sozinha. Ela apenas grita: "Fui clicada!"
	clicked.emit(self)

# O Tabuleiro vai chamar esta função para forçar a carta a virar para cima
func _turn_face_up():
	pivot_offset = size / 2.0
	is_flipped = true
	disabled = true
	var tween = create_tween()
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	tween.tween_callback(func(): texture_normal = front_texture)
	tween.tween_property(self, "scale:x", 1.0, 0.15)

# O Tabuleiro vai chamar esta função se o jogador errar o par
func _turn_face_down():
	pivot_offset = size / 2.0
	is_flipped = false
	var tween = create_tween()
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	tween.tween_callback(func(): texture_normal = back_texture)
	tween.tween_property(self, "scale:x", 1.0, 0.15)
	tween.tween_callback(func(): disabled = false)

func _set_matched():
	is_matched = true
	disabled = true
