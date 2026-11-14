extends AnimatedSprite2D

enum Estado { IDLE, BORED, LOOKING_BACK }

var estado_atual = Estado.IDLE
var tempo_para_piscar: float = 5.0
var cronometro_piscar: float = 0.5

func _ready() -> void:
	play("idle")
	# Garante que a animação de piscar não fique em loop infinito
	if sprite_frames.has_animation("blink"):
		sprite_frames.set_animation_loop("blink", false)
	
	# Conecta o sinal de fim de animação para voltar ao idle após piscar
	animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	# Se o botão de olhar para trás estiver pressionado, dá prioridade total
	if Input.is_action_pressed("gm_behind"):
		if estado_atual != Estado.LOOKING_BACK:
			estado_atual = Estado.LOOKING_BACK
			play("backwards")
		return
		
	if estado_atual == Estado.LOOKING_BACK and not Input.is_action_pressed("gm_behind"):
		# Se soltou o botão e o Principal ainda está te punindo, volta pro tédio de forma segura!
		if motivos_tedio > 0:
			estado_atual = Estado.BORED
			play("bored")
		else:
			estado_atual = Estado.IDLE
			play("idle")

	# Trava a animação em BORED se ele estiver na detenção, ignorando falsos sinais rápidos
	if estado_atual == Estado.BORED:
		if animation != "bored":
			play("bored")
		return

	# Lógica normal de piscar os olhos
	if estado_atual == Estado.IDLE and animation != "blink":
		cronometro_piscar += delta
		if cronometro_piscar >= tempo_para_piscar:
			cronometro_piscar = 0.0
			play("blink")


# Retorna ao IDLE normal assim que a animação de piscar terminar
func _on_animation_finished() -> void:
	if animation == "blink":
		play("idle")

# --- FUNÇÕES PÚBLICAS (Chamadas por outros scripts do jogo) ---

# Chame esta função quando entrar na detenção ou iniciar o minigame da Playtime
var motivos_tedio: int = 0

func definir_entediado(ativar: bool) -> void:
	print("Boyfriend recebeu o comando! Ativar tédio? ", ativar) # Linha de teste
	if ativar:
		estado_atual = Estado.BORED
		play("bored") # Certifique-se que o nome na sua SpriteFrames é exatamente "bored"
	else:
		estado_atual = Estado.IDLE
		cronometro_piscar = 0.0
		play("idle") # Certifique-se que o nome é "idle"
