extends CharacterBody2D

const speed = 30
var current_state = SIDE_LEFT

var dir = Vector2.RIGHT
var start_pos

var is_roaming
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	is_roaming = true  # Enable movement

func _process(delta):
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE and !is_chatting:
		if dir.x == -1: 
			$AnimatedSprite2D.play("walk_w")
		elif dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		elif dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
		elif dir.y == -1:
			$AnimatedSprite2D.play("walk_n")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				current_state = MOVE  # Ensure the NPC actually moves
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")			

func choose(array):
	array.shuffle()
	return array.front()
	
func move(_delta): 
	if !is_chatting:
		velocity = dir * speed
		move_and_slide()

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
