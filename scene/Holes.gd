extends Node2D

# 用texture存洞的信息

const MAX_HOLE = 128
var it = ImageTexture.new()
var image = Image.new()
var stream = StreamPeerBuffer.new()
var mat
var bytes = PoolByteArray([])
const FORMAT_SIZE = 4 # rgba
const FLOAT_BYTES = 4
const MAX_SIZE = FORMAT_SIZE * FLOAT_BYTES * MAX_HOLE

func _ready():
  mat = $Rect.get_material()

# 调用这个加入新的洞
func add_hole_a(r: float, pos: Vector2, alpha: float):
  if bytes.size() >= MAX_SIZE:
    return
  pack_float(r)
  pack_float(pos.x)
  pack_float(pos.y)
  pack_float(alpha)

# 缺省alpha
func add_hole(r: float, pos: Vector2):
  add_hole_a(r, pos, 0)

func clear_holes():
  bytes = PoolByteArray([])

# 最后调这个画，每帧一次之类的
func draw_holes():
  while bytes.size() < MAX_SIZE:
    bytes.append(0)
  image.create_from_data(MAX_HOLE, 1, false, Image.FORMAT_RGBAF, bytes)
  it.create_from_image(image)
  $Sprite.texture = it
  mat.set_shader_param("holes_tex", it)

func pack_float(x: float):
  stream.clear()
  stream.put_float(x)
  stream.seek(0)
  for i in range(4):
    bytes.append(stream.get_8())