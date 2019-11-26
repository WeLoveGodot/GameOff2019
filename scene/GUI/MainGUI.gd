extends CanvasLayer

# Declare member variables here. Examples:

const delta_tech = 5



const consumption_tech = 20

# var b = "text"
var _tech = 0
var _energy = 0
var _planet
var _resource = 0

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



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	menu_animator = get_node("Animator")
#  $ProgressBar.value = _tech
  #$Resource.text = String(_resource)

func set_planet(planet):
  _planet = planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
func Upgrade(planet):
  if planet.energy >= consumption_tech:
    planet.energy -= consumption_tech
    planet.tech += delta_tech
    #$Resource.text = str(planet.resource)
    #$ProgressBar.value = planet.tech


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