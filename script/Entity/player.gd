extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

enum player_states {MOVE, SWORD}
var current_states = player_states.MOVE
var speed = 70
var input_movement = Vector2.ZERO
var health = Player_data.player_health

func _ready():
	print(health)

func _physics_process(delta):
	match current_states:
		player_states.MOVE:
			input_move()
		player_states.SWORD:
			sword()
	
func input_move():
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position" , input_movement)
		anim_tree.set("parameters/Move/blend_position" , input_movement)
		anim_tree.set("parameters/Sword/blend_position" , input_movement)
		anim_state.travel("Move")
		velocity = input_movement * speed
	if input_movement == Vector2.ZERO:
		anim_state.travel("Idle")	
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("ui_sword"):
		current_states = player_states.SWORD

	move_and_slide()


func sword():
	anim_state.travel("Sword") 
	

func on_states_reset():
	current_states = player_states.MOVE


 
