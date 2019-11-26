extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
  var is_win = Global.is_win
  $Win.visible = is_win
  $Fail.visible = !is_win

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass


func _on_RetryButton_pressed():
  get_tree().change_scene("res://scene/Game.tscn")

func _on_BackButton_pressed():
  get_tree().change_scene("res://scene/GUI/Menu.tscn")
