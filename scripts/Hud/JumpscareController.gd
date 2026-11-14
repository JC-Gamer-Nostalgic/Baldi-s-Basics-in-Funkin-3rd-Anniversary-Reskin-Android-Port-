extends TextureRect

@export var baldi_node: Node3D
@export var jumpscare_sound: AudioStream 
@export_file("*.tscn") var game_over_scene: String = "res://Scenes/GameOver.tscn"
@export var duration: float = 1.2

var _is_triggered: bool = false

func _ready() -> void:
	visible = false

func trigger_jumpscare() -> void:
	if _is_triggered:
		return
	_is_triggered = true
	
	# Faz o Baldi 3D/Sprite desaparecer da cena
	if baldi_node:
		baldi_node.visible = false
	
	# Mostra a imagem do jumpscare em tela cheia
	visible = true
	
	if jumpscare_sound:
		var audio_player := AudioStreamPlayer.new()
		audio_player.stream = jumpscare_sound
		add_child(audio_player)
		audio_player.play()
	
	get_tree().paused = true
	await get_tree().create_timer(duration, true).timeout
	
	get_tree().paused = false
	get_tree().change_scene_to_file(game_over_scene)
