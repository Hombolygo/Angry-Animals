extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
const ANIMAL = preload("res://Scenes/Animal.tscn")

func spawn_animal() -> void:
	var animal = ANIMAL.instantiate();
	animal.position = marker_2d.position;
	add_child(animal);
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_animal()
	SignalHub.animal_died.connect(spawn_animal);
	pass # Replace with function body.
