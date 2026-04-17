extends CanvasLayer

@onready var color_rect = $ColorRect

# Aqui criamos o nosso catálogo de paletas!
var paletas = [
	{"nome": "Iced Pine", "cor1": Color(0.2, 0.7, 0.6, 1.0), "cor2": Color(0.95, 0.95, 0.85, 1.0)},
	{"nome": "Café Quente", "cor1": Color(0.4, 0.2, 0.1, 1.0), "cor2": Color(0.9, 0.8, 0.7, 1.0)},
	{"nome": "Cyber-Uva", "cor1": Color(0.2, 0.05, 0.3, 1.0), "cor2": Color(0.8, 0.3, 0.9, 1.0)},
	{"nome": "Oceano Profundo", "cor1": Color(0.05, 0.15, 0.3, 1.0), "cor2": Color(0.2, 0.5, 0.7, 1.0)}
]

func _ready():
	# Inicia o jogo com a primeira paleta (Iced Pine)
	mudar_paleta(0)

func mudar_paleta(index: int):
	# Pega o material do ColorRect e injeta as novas cores no Shader
	var shader_material = color_rect.material as ShaderMaterial
	shader_material.set_shader_parameter("cor_1", paletas[index].cor1)
	shader_material.set_shader_parameter("cor_2", paletas[index].cor2)
