shader_type canvas_item;

// Estas variáveis vão aparecer no Inspector para você mudar as cores depois!
uniform vec4 cor_1 : source_color = vec4(0.2, 0.7, 0.6, 1.0); // Verde-água
uniform vec4 cor_2 : source_color = vec4(0.95, 0.95, 0.85, 1.0); // Creme suave
uniform float tamanho_quadrado = 50.0;
uniform vec2 velocidade = vec2(30.0, 30.0); // Velocidade do movimento (X e Y)

void fragment() {
	// Pega a posição do pixel e soma com o Tempo para criar o movimento
	vec2 pos = FRAGCOORD.xy + (TIME * velocidade);
	
	// Divide a tela em uma grade matemática baseada no tamanho
	float x = floor(pos.x / tamanho_quadrado);
	float y = floor(pos.y / tamanho_quadrado);
	
	// Se a soma da linha e coluna for par, pinta com a cor 1. Se for ímpar, cor 2.
	if (mod(x + y, 2.0) == 0.0) {
		COLOR = cor_1;
	} else {
		COLOR = cor_2;
	}
}