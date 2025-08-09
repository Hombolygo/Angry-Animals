extends TextureButton

@export var level_number : String = "1";
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = level_number;
	score_label.text = "%d" % ScoreManager.get_level_best(level_number)
	pass # Replace with function body.




func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
	pass # Replace with function body.


func _on_pressed() -> void:
	ScoreManager.level_number = level_number;
	get_tree().change_scene_to_file("res://Scenes/Level%s.tscn" % level_number)
	pass # Replace with function body.
