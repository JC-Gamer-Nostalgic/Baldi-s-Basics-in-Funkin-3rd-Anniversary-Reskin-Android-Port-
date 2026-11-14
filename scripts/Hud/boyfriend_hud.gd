extends Control

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var blink_timer: Timer = $BlinkTimer

# Estados do Boyfriend
enum Estado { IDLE, TEDIO, OLHANDO_TRAS }
var estado_atual: Estado = Estado.IDLE

# Controladores de estado internos
var na_detencao: bool = false

func _ready() -> void:
	sprite.play("idle")
	configurar_timer_piscar()

func configurar_timer_piscar() -> void:
	blink_timer.wait_time = 5.0
	blink_timer.one_shot = false
	blink_timer.timeout.connect(_ao_piscar_timer_timeout)
	blink_timer.start()

func _process(_delta: float) -> void:
	# DETECÇÃO AUTOMÁTICA DE SITUAÇÕES (Monitorando as variáveis do Port)
	var em_situacao_de_tedio: bool = false
	
	if has_node("/root/global"):
		var global = get_node("/root/global")
		
		# Adicione isso logo no início da sua func _process no script do Boyfriend:
		if na_detencao == false and sprite.animation == "bored":
			sprite.play("bored")

		# 1. Checa a detenção automaticamente por variações de nomes comuns do Port
		if "detentionTimer" in global and global.detentionTimer > 0.0001:
			em_situacao_de_tedio = true
		elif "detention_timer" in global and global.detention_timer > 0.0001:
			em_situacao_de_tedio = true
		elif "detention" in global and global.detention == true:
			em_situacao_de_tedio = true
			
		# 2. Checa a Playtime (Pular Corda) por variações de nomes comuns do Port
		if "jumpRope" in global and global.jumpRope == true:
			em_situacao_de_tedio = true
		elif "jump_rope" in global and global.jump_rope == true:
			em_situacao_de_tedio = true
		elif "playtimeActive" in global and global.playtimeActive == true:
			em_situacao_de_tedio = true
			
	# Atualiza o estado com base na varredura automática do ambiente
	na_detencao = em_situacao_de_tedio

	# ----------------------------------------------------
	# LÓGICA DE ANIMAÇÕES

	# Tecla ESPAÇO física ou comando nativo de olhar para trás do Port
	var apertando_olhar_tras: bool = (
		Input.is_key_pressed(KEY_SPACE) or 
		Input.is_action_pressed("gm_behind")
	)

	# 1. VISÃO TRASEIRA (Prioridade Máxima)
	if apertando_olhar_tras:
		if estado_atual != Estado.OLHANDO_TRAS:
			estado_atual = Estado.OLHANDO_TRAS
		if sprite.animation != "look_back":
			sprite.play("look_back")
		return

	# Reseta se acabou de soltar o Espaço / gm_behind
	if estado_atual == Estado.OLHANDO_TRAS and not apertando_olhar_tras:
		estado_atual = Estado.IDLE
		sprite.play("idle")

	# 2. ESTADO DE TÉDIO AUTOMÁTICO (Detenção ou Playtime detetados)
	if na_detencao:
		estado_atual = Estado.TEDIO
		if blink_timer.is_stopped():
			blink_timer.stop()
		if sprite.animation != "bored":
			sprite.play("bored")
		return

	# 3. RETORNO AO ESTADO PADRÃO (Corredores seguros)
	if estado_atual != Estado.IDLE:
		estado_atual = Estado.IDLE
		if blink_timer.is_stopped():
			blink_timer.start()

	if sprite.animation != "bored" or (sprite.animation != "idle" and sprite.animation != "blink"):
		sprite.play("idle")

func _ao_piscar_timer_timeout() -> void:
	if estado_atual == Estado.IDLE:
		sprite.play("blink") 
		await sprite.animation_finished
		if estado_atual == Estado.IDLE: 
			sprite.play("idle")
