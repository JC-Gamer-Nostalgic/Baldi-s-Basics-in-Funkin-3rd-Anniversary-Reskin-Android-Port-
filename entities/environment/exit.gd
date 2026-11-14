extends Node3D


func activate():
	lower()

func lower():
	position.y = -10.0

func raise():
	position.y = 0.0

func escape_activate(): # called in math minigame (has to be in escape group)
	raise()


func _on_near_trigger_body_entered(_body):
	if Global.escapesReached < 3 && Global.escapeMode:
		lower()
		Global.exit_reached()
		$Switch.play()
		# alert baldi
		if is_instance_valid(Global.baldi):
			Global.baldi.hear(global_position,8)

func _on_door_11_ready() -> void:
	pass # Replace with function body.

var ja_tocada: bool = false
var eh_porta_falsa: bool = false # Deve ser true quando a porta bloquear/sumir

func _on_area_3d_body_entered(body: Node3D) -> void:
	# Verifica se quem encostou é o jogador e se esta porta é uma das 3 falsas
	if body.is_in_group("player") and eh_porta_falsa and not ja_tocada:
		ja_tocada = true
		
		# Chama a função no nó pai/gerenciador da escola
		var school = get_tree().current_scene
		if school.has_method("registrar_porta_falsa"):
			school.registrar_porta_falsa()
