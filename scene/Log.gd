extends Node

var _channel = {
	ai = true,
}

func log(channel: String, text):
	if _channel[channel]:
		print("[" + channel + "]" + text)

func _ready():
	pass # Replace with function body.
