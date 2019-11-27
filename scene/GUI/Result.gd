extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _end_table = {
  Global.EResult.WIN: $Win,
  Global.EResult.FAIL: $Fail,
  Global.EResult.NO_TECH: $NoTech,
}
func _ready():
  var type = Global.result_type
  _end_table[type].visible = true


func _on_RetryButton_pressed():
  get_tree().change_scene("res://scene/Game.tscn")

func _on_BackButton_pressed():
  get_tree().change_scene("res://scene/GUI/Menu.tscn")
