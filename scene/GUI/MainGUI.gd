extends CanvasLayer


# Game Variables
var game
var camera
var explore
var attack

# GUI const values
const BUTTON_EXPAND_DURATION = 0.2
const BUTTON_INFO_DURATION = 0.4
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
onready var player_level = get_node("Level/Num")
onready var player_tech = get_node("Tech_Factor/Num")
onready var player_resource = get_node("Resource/Num")
onready var button_info = get_node("ButtonInfo")
onready var button_info_text = get_node("ButtonInfo/Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	menu_animator = get_node("Animator")
	game = get_parent()
	camera = game.get_node("Camera")
	progressor.set_max(100)
	
#  $ProgressBar.value = _tech
  #$Resource.text = String(_resource)

func _process(delta):
	if game.me:
		#player_health.set_text(“ENERGY : ” + String(game.me.energy))
		player_level.set_text("LEVEL : " + String(game.me.level))
		player_tech.set_text("GROTH RATE : " + String(game.me.tech_factor))
		player_resource.set_text("ENERGY : " + String(game.me.energy))
		print(str(game.me.tech) + " : " + str(game.me.progress))
		progressor.set_value( game.me.progress * 100)
	pass
	


func _on_Accelerate_mouse_entered():
	menu_animator.interpolate_property(accelerate_button, "rect_scale",\
									 accelerate_button.get_scale(), accelerate_button.get_scale() * BUTTON_EXPAND_FACOTR,\
									 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	var cost = Global.SKILL_DICT[Global.ESkill.ACC].cost.call_func(game.me)
	menu_animator.interpolate_property(button_info, "modulate",\
								 Color(1,1,1,0), Color(1,1,1,1),\
								 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	button_info_text.set_text("Accelerate\n"+
							  "Energy cost : " + str(cost) + "\n" +
							  "Effect : Growth Rate x 2")
	menu_animator.start()


func _on_Accelerate_mouse_exited():
	menu_animator.interpolate_property(accelerate_button, "rect_scale",\
								 accelerate_button.get_scale(), BUTTON_NORMAL_SCALE,\
								 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.interpolate_property(button_info, "modulate",\
								 Color(1,1,1,1), Color(1,1,1,0),\
								 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Explore_mouse_entered():
	menu_animator.interpolate_property(explore_button, "rect_scale",\
								 explore_button.get_scale(), explore_button.get_scale() * BUTTON_EXPAND_FACOTR,\
								 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	var cost = Global.SKILL_DICT[Global.ESkill.EXPR].cost.call_func(game.me)
	menu_animator.interpolate_property(button_info, "modulate",\
								 Color(1,1,1,0), Color(1,1,1,1),\
								 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	button_info_text.set_text("Explore\n"+
							  "Energy cost : " + str(cost) + "\n" +
							  "Effect : Launch a explorer")
	menu_animator.start()


func _on_Explore_mouse_exited():
	menu_animator.interpolate_property(explore_button, "rect_scale",\
							 explore_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.interpolate_property(button_info, "modulate",\
							 Color(1,1,1,1), Color(1,1,1,0),\
							 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()


func _on_Expand_mouse_entered():
	menu_animator.interpolate_property(expand_button, "rect_scale",\
							 expand_button.get_scale(), expand_button.get_scale() * BUTTON_EXPAND_FACOTR,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	var cost = Global.SKILL_DICT[Global.ESkill.EXPD].cost.call_func(game.me)
	menu_animator.interpolate_property(button_info, "modulate",\
								 Color(1,1,1,0), Color(1,1,1,1),\
								 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	button_info_text.set_text("Expand\n"+
							  "Energy cost : " + str(cost) + "\n" +
							  "Effect : Enlarge the filed of vision")
	menu_animator.start()

func _on_Expand_mouse_exited():
	menu_animator.interpolate_property(expand_button, "rect_scale",\
							 expand_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.interpolate_property(button_info, "modulate",\
							 Color(1,1,1,1), Color(1,1,1,0),\
							 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.start()

func _on_Attack_mouse_entered():
	menu_animator.interpolate_property(attack_button, "rect_scale",\
							 attack_button.get_scale(), attack_button.get_scale() * BUTTON_EXPAND_FACOTR,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	var cost = Global.SKILL_DICT[Global.ESkill.ATK].cost.call_func(game.me)
	menu_animator.interpolate_property(button_info, "modulate",\
								 Color(1,1,1,0), Color(1,1,1,1),\
								 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	button_info_text.set_text("Attack\n"+
							  "Energy cost : " + str(cost) + "\n" +
							  "Effect : Attack other planet")
	menu_animator.start()

func _on_Attack_mouse_exited():
	menu_animator.interpolate_property(attack_button, "rect_scale",\
							 attack_button.get_scale(), BUTTON_NORMAL_SCALE,\
							 BUTTON_EXPAND_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	menu_animator.interpolate_property(button_info, "modulate",\
							 Color(1,1,1,1), Color(1,1,1,0),\
							 BUTTON_INFO_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
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
