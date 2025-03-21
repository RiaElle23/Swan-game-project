extends Node2D

@onready var black_screen = $BlackScreen
@onready var godot_logo = $GodotLogo
@onready var loading_screen = $LoadingScreen
@onready var panel_container = $PanelContainer
@onready var dialogue_box = $DialogueBox
@onready var title_screen = $TitleScreen

var current_panel = 0
var panels = []  # List of comic panels

func _ready():
	# Store comic panels
	panels = $PanelContainer.get_children()
	
	# Make everything invisible except black screen
	black_screen.visible = true
	panel_container.visible = false
	dialogue_box.visible = false
	title_screen.visible = false

	# Start cutscene sequence
	start_sequence()

func start_sequence():
	await get_tree().create_timer(2).timeout
	fade_in(godot_logo)
	await get_tree().create_timer(2).timeout
	fade_out(godot_logo)

	await get_tree().create_timer(1).timeout
	fade_in(loading_screen)
	await get_tree().create_timer(2).timeout
	fade_out(loading_screen)

	await get_tree().create_timer(1).timeout
	start_cutscene()

func start_cutscene():
	black_screen.visible = false
	panel_container.visible = true
	dialogue_box.visible = true
	show_next_panel()

func show_next_panel():
	if current_panel < panels.size():
		fade_in(panels[current_panel])
		current_panel += 1
	else:
		end_cutscene()

func end_cutscene():
	fade_in(title_screen)
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/main_gameplay.tscn")  # Load game scene

func fade_in(node):
	node.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1, 1)

func fade_out(node):
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0, 1)
	await tween.finished
	node.visible = false
