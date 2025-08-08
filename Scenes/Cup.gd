extends StaticBody2D

class_name Cup

@onready var animation_player: AnimationPlayer = $AnimationPlayer

static var cups : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cups += 1;
	pass # Replace with function body.


func die() -> void:
	
	animation_player.play("Vanish");


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	cups -= 1;
	queue_free();
