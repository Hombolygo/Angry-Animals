extends Node

signal animal_died;

func animal_died_emit() -> void:
	animal_died.emit();
