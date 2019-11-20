extends CanvasLayer

# Declare member variables here. Examples:

const delta_tech = 5



const consumption_tech = 20

# var b = "text"
var _tech = 0
var _energy = 0
var _planet
var _resource = 0


# Called when the node enters the scene tree for the first time.
func _ready():
  $ProgressBar.value = _tech
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
    $Resource.text = str(planet.resource)
    $ProgressBar.value = planet.tech


func _on_Upgrade_pressed():
  print("Upgrade Button Clicked")
  $ProgressBar.value += delta_tech
  print($ProgressBar.value)
  $Resource
