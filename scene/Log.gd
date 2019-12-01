extends Node

var _channel = {
	ai2 = false,
	ai = false,
	loading = false,
	debug = false, # 要经常关的
	info = true,
	warning = true,
	error = true,
}

func log(channel: String, text):
	if _channel[channel]:
		print("[%s] %s" % [channel, text])

func _ready():
	pass # Replace with function body.
