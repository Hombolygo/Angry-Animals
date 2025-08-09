extends Node

const SCORES_PATH = "user://animals.tres"

var level_number : String = "";

var level_scores : LevelScoresResource;

func _ready() -> void:
	load_scores();

func load_scores() -> void:
	if ResourceLoader.exists(SCORES_PATH):
		level_scores = load(SCORES_PATH);
	if !level_scores:
		level_scores = LevelScoresResource.new()

func save_scores() -> void:
	ResourceSaver.save(level_scores, SCORES_PATH)

func get_level_best(level: String) -> int:
	return level_scores.get_level_best(level);
	
func set_scores_for_level(level: String, score: int) -> void:
	level_scores.update_level_score(level, score);
	save_scores();
