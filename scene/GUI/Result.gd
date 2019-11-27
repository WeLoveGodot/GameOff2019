extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _end_table = {
  Global.EResult.ATK_WIN : $AttackWin,
  Global.EResult.ATK_FAIL : $AttackFail,
  Global.EResult.SUICIDE : $SelfDestroyFail,
  Global.EResult.TIME_LIMIT_FAIL : $TimeLimitFail,
  Global.EResult.TECH_FAIL : $TechFail,
  Global.EResult.NO_TECH : $NoTech,
  Global.EResult.NO_ENERGY : $NoEnergy,
  Global.EResult.TECH_WIN : $TechWin,
}
func _ready():
  var type = Global.result_type
  _end_table[type].visible = true


func _on_RetryButton_pressed():
  get_tree().change_scene("res://scene/Game.tscn")

func _on_BackButton_pressed():
  get_tree().change_scene("res://scene/GUI/Menu.tscn")
