extends Node

# No script principal da escola (ex: School.gd)
@onready var world_env: WorldEnvironment = $WorldEnvironment

var portas_falsas_tocadas: int = 0
var nevoa_ativada: bool = false

func registrar_porta_falsa() -> void:
	if nevoa_ativada:
		return
		
	portas_falsas_tocadas += 1
	print("Portas falsas tocadas: ", portas_falsas_tocadas)

	if portas_falsas_tocadas >= 3:
		ativar_nevoa_vermelha()

func ativar_nevoa_vermelha() -> void:
	nevoa_ativada = true
	if world_env and world_env.environment:
		var env = world_env.environment
		env.fog_enabled = true
		env.fog_light_color = Color(0.5, 0.0, 0.0, 1.0) # Vermelho escuro
		env.fog_density = 0.2
