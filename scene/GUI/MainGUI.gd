extends CanvasLayer

# Declare member variables here. Examples:

# Game Variables
var game
var camera
var explore
var attack

# GUI const values
const BUTTON_EXPAND_DURATION = 0.2
const BUTTON_EXPAND_FACOTR = 1.2
const BUTTON_NORMAL_SCALE = Vector2(1,1)

# GUI variables
var arrow = load("res://resource/art/arrow.png")
var menu_animator = null
onready var accelerate_button = get_node("MainGUIButtons/Accelerate")
onready var explore_button = get_node("MainGUIButtons/Explore")
onready var attack_button = get_node("MainGUIButtons/Attack")
onready var expand_button = get_node("MainGUIButtons/Expand")
onready var progressor = get_node("Progressor")
onready var player_health = get_node("PlayerInfo/HP/Num")
onready var player_level = get_node("PlayerInfo/Level/Num")
onready var player_tech = get_node("PlayerInfo/Tech/Num")
onready var player_resource = get_node("PlayerInfo/Resource/Num")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	menu_animator = get_node("Animator")
	game = get_parent()
	camera = game.get_node("Camera")
	
#  $ProgressBar.value = _tech
  #$Resource.text = String(_resource)

func _process(delta):
	if game.me:
		#player_health.set_text(“ ” + String(game.me.energy))
		player_level.set_text(" " + String(game.me.level))
		player_tech.set_text(" " + String(game.me.tech))
		player_resource.set_text(" " + String(game.me.energy))



func _on_Upgrade_pressed():
  print("Upgrade Button Clicked")
  #$ProgressBar.value += delta_tech
  print($ProgressBar.value)
  #$Resource


func _on_Accelerate_mouse_entered():
	print(accelerate_button.get("rect_scale"))
	menu_animator.interpolate_property(accelerate_button, "rect_scale",\
									 accelerate_button.get_scale(), accelerate_button.get_scale() * BUTTON_EXPAND_FACOTR,\
									 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()


func _on_Accelerate_mouse_exited():
	menu_animator.interpolate_property(accelerate_button, "rect_scale",\
								 accelerate_button.get_scale(), BUTTON_NORMAL_SCALE,\
								 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Explore_mouse_entered():
	menu_animator.interpolate_property(explore_button, "rect_scale",\
								 explore_button.get_scale(), explore_button.get_scale() * BUTTON_EXPAND_FACOTR,\
								 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()


func _on_Explore_mouse_exited():
	menu_animator.interpolate_property(explore_button, "rect_scale",\
							 explore_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()


func _on_Expand_mouse_entered():
	menu_animator.interpolate_property(expand_button, "rect_scale",\
							 expand_button.get_scale(), expand_button.get_scale() * BUTTON_EXPAND_FACOTR,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Expand_mouse_exited():
	menu_animator.interpolate_property(expand_button, "rect_scale",\
							 expand_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Attack_mouse_entered():
	menu_animator.interpolate_property(attack_button, "rect_scale",\
							 attack_button.get_scale(), attack_button.get_scale() * BUTTON_EXPAND_FACOTR,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Attack_mouse_exited():
	menu_animator.interpolate_property(attack_button, "rect_scale",\
							 attack_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Accelerate_pressed():
	game.get_node("Skill").use_skill(
		game.me,
		Global.ESkill.ACC,
		null
	)


func _on_Expand_pressed():
	game.get_node("Skill").use_skill(game.me, Global.ESkill.EXPD, null)


func _on_Explore_pressed():
	camera.enter_draw_arrow_mode(Global.ESkill.EXPR, BUTTON_LEFT, null)


func _on_Attack_pressed():
	camera.enter_draw_arrow_mode(Global.ESkill.ATK, BUTTON_LEFT, game.me)
