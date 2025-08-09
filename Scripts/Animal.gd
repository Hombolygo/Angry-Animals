extends RigidBody2D

class_name Animal

enum AnimalState {Ready, Drag, Release };

const DRAG_LIMIT_MAX: Vector2 = Vector2(0,60);
const DRAG_LIMIT_MIN:Vector2 = Vector2(-60,0);
const IMPULSE_MULT : float = 20.0;
const IMPULSE_MAX : float = 1200.0;

@onready var arrow: Sprite2D = $Arrow
@onready var label: Label = $Label
@onready var strech_sound: AudioStreamPlayer2D = $StrechSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var kick_sound: AudioStreamPlayer2D = $KickSound

var _state : AnimalState = AnimalState.Ready;
var _start : Vector2 = Vector2.ZERO;
var _drag_start : Vector2 = Vector2.ZERO;
var _drag_vector : Vector2 = Vector2.ZERO;
var _arrow_scale_x : float = 0.0;

func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"):
		call_deferred("change_state", AnimalState.Release);
		

func setup() -> void:
	_start = position;
	_arrow_scale_x = arrow.scale.x;
	arrow.hide();
	_start = position;

func die() -> void:
	SignalHub.animal_died.emit();
	queue_free();
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	update_debug_label();
	update_state();
	pass
	
#region misc
func update_debug_label() -> void:
	var string : String = "St:%s SL:%s FR:%s\n" % [
		AnimalState.keys()[_state], sleeping, freeze
	]
	string += "drag_start: %.1f, %.1f\n" % [_drag_start.x, _drag_start.y];
	string += "drag_vector: %.1f, %.1f" % [_drag_vector.x, _drag_vector.y];
	label.text = string;
	pass
#endregion

#region drag

func update_arrow_scale() -> void:
	var imp_len: float = calculate_impulse().length();
	var perc: float = clamp(imp_len / IMPULSE_MAX, 0.0, 1.0);
	arrow.scale.x = lerp(_arrow_scale_x, _arrow_scale_x*2, perc);
	arrow.rotation = (_start - position).angle();

func handle_dragging() -> void:
	var new_drag_vector : Vector2 = get_global_mouse_position() - _drag_start;
	
	new_drag_vector = new_drag_vector.clamp(DRAG_LIMIT_MIN, DRAG_LIMIT_MAX);
	
	var diff : Vector2 = new_drag_vector - _drag_vector
	if diff.length() > 0 and strech_sound.playing == false:
		strech_sound.play();
	
	_drag_vector = new_drag_vector
	
	update_arrow_scale()
	position = _start + _drag_vector

func start_dragging() -> void:
	arrow.show()
	_drag_start = get_global_mouse_position()
	pass

#endregion

#region release

func calculate_impulse() -> Vector2:
	return _drag_vector * -IMPULSE_MULT;

func start_release() -> void:
	arrow.hide();
	launch_sound.play();
	freeze = false;
	apply_central_impulse(calculate_impulse())
	SignalHub.attempt_made.emit();
	pass

#endregion

#region state
func update_state() -> void:
	match _state:
		AnimalState.Drag:
			handle_dragging()

func change_state(new_state : AnimalState) -> void:
	if _state == new_state:
		return;
	_state = new_state;
	
	match _state:
		AnimalState.Drag:
			start_dragging();
		AnimalState.Release:
			start_release();
#endregion

#region signal
func screen_exited() -> void:
	die();
	pass # Replace with function body.


func _on_rigid_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready:
		change_state(AnimalState.Drag);
	pass # Replace with function body.


func _on_sleeping_state_changed() -> void:
	if sleeping:
		for body in get_colliding_bodies():
			if body is Cup:
				body.die();
				call_deferred("die");
	pass # Replace with function body.


func _on_body_entered(body: Node) -> void:
	if body is Cup and not kick_sound.playing:
		kick_sound.play();
	pass # Replace with function body.
	
#endregion
