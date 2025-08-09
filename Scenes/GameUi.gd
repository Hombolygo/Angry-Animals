extends Control

@onready var attempt_number_label: Label = $MarginContainer/VBoxContainer/HBoxContainer2/AttemptNumberLabel
@onready var v_box_container_2: VBoxContainer = $MarginContainer/VBoxContainer2
@onready var music: AudioStreamPlayer2D = $Music
@onready var level_number_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/LevelNumberLabel

var _attempts : int = 0; 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_number_label.text = ScoreManager.level_number;
	attempt_number_label.text = "%s" % _attempts;
	pass # Replace with function body.

func _enter_tree() -> void:
	SignalHub.attempt_made.connect(on_attemp_made);
	SignalHub.cup_destroyed.connect(on_cup_destroyed);
	
func on_cup_destroyed(remainings : int) -> void:
	if remainings <= 0:
		v_box_container_2.show();
		music.play()
		ScoreManager.set_scores_for_level(ScoreManager.level_number, _attempts)
	pass

func on_attemp_made() -> void:
	_attempts += 1;
	attempt_number_label.text = "%s" % _attempts;
	pass
