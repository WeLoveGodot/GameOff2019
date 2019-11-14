extends Node2D

# 用texture存洞的信息

const MAX_HOLE = 128
var holes = []
var it = ImageTexture.new()
var image = Image.new()
var stream = StreamPeerBuffer.new()
var mat
var bytes = PoolByteArray([])

var saved = false
# Called when the node enters the scene tree for the first time.
func _ready():
  # test preformance
  mat = $Rect.get_material()
  for i in range(4):
    holes.append({"pos": Vector2(i * 120, i * 120), "r": 100.0})
  pack_holes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pack_holes()

func pack_float(x: float):
  stream.clear()
  stream.put_float(x)
  stream.seek(0)
  for i in range(4):
    bytes.append(stream.get_8())

func pack_holes():
  # image.lock()
  # image.fill(Color("#000000"))
  # image.unlock()
  bytes = PoolByteArray([])
  for i in range(holes.size()):
    var hole = holes[i]
    pack_float(hole["r"])
    pack_float(hole["pos"].x)
    pack_float(hole["pos"].y)
  while bytes.size() < 3 * 4 * MAX_HOLE:
    bytes.append(0)
  image.create_from_data(MAX_HOLE, 1, false, Image.FORMAT_RGBF, bytes)
  if !saved:
    image.save_png("res://resource/texture/test.png")
    saved = true
  it.create_from_image(image)
  $Sprite.texture = it
  mat.set_shader_param("holes_tex", it)