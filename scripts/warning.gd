extends CanvasLayer
@export var warnings:PackedStringArray = [
"[center][color=RED]WARNING!
[color=WHITE]All assets in this port were traced directly from gameplay videos by YouTubers playing the [color=GREEN]Baldi's Basics In Funkin' 3rd Anniversary Reskin! [color=WHITE]mod; I took screenshots and traced them using the Ibis[color=LIGHTBLUE]Paint [color=GRAY]X [color=WHITE]app. Anyway, redrawing EVERYTHING from the original was a [color=RED]massive headache[color=WHITE]. Well, that's all—have fun.",

]
var warningID = 0

func _ready():
	update_text()

func update_text():
	$Label.text = warnings[warningID]

func _input(event):
	if "pressed" in event and not (event is InputEventKey and event.echo) and not event is InputEventScreenTouch: # Remove touch because it simulates mouse too
		if event.pressed:
			if warningID < warnings.size()-1:
				warningID += 1
				update_text()
			else:
				get_tree().change_scene_to_file("res://scenes/menu.tscn")
