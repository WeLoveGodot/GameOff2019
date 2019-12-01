extends Camera2D

# Camera control settings:
# key - by keyboard
# drag - by clicking mouse button, right mouse button by default;
# edge - by moving mouse to the window edge
# wheel - zoom in/out by mouse wheel
export (bool) var key = true
export (bool) var drag = true
export (bool) var edge = true
export (bool) var wheel = true

export (int) var zoom_out_limit = 100

# Camera speed in px/s.
export (int) var camera_speed = 700

# Initial zoom value taken from Editor.
var camera_zoom = get_zoom()

# Value meaning how near to the window edge (in px) the mouse must be,
# to move a view.
export (int) var camera_margin = 0

# It changes a camera zoom value in units... (?, but it works... it probably
# multiplies camera size by 1+camera_zoom_speed)
const camera_zoom_speed = Vector2(0.05, 0.05)

# Vector of camera's movement / second.
var camera_movement = Vector2()

# Previous mouse position used to count delta of the mouse movement.
var _prev_mouse_pos = null

# INPUTS

# Right mouse button was or is pressed.
var __rmbk = false
# Move camera by keys: left, top, right, bottom.
var __keys = [false, false, false, false]

onready var draw_arrow_mode = false
onready var end_draw_arrow_action = null
onready var end_draw_arrow_key = null
var mouse_position

onready var game = get_parent()

var _shake_offset = 0.0

func _ready():
  set_h_drag_enabled(false)
  set_v_drag_enabled(false)
  set_enable_follow_smoothing(true)
  set_follow_smoothing(10)
  set_process(false)

func _process(delta):
  update()

func _physics_process(delta):
  # Move camera by keys defined in InputMap (ui_left/top/right/bottom).
  if key:
    if __keys[0]:
      camera_movement.x -= camera_speed * delta
    if __keys[1]:
      camera_movement.y -= camera_speed * delta
    if __keys[2]:
      camera_movement.x += camera_speed * delta
    if __keys[3]:
      camera_movement.y += camera_speed * delta

  # Move camera by mouse, when it's on the margin (defined by camera_margin).
  if edge:
    #var rec = get_viewport().get_visible_rect()
    var rec = Global.WINDOW_SIZE
    var v = get_local_mouse_position() + rec/2

    if rec.x - v.x <= camera_margin:
      camera_movement.x += camera_speed * delta
    if v.x <= camera_margin:
      camera_movement.x -= camera_speed * delta
    if rec.y - v.y <= camera_margin:
      camera_movement.y += camera_speed * delta
    if v.y <= camera_margin:
      camera_movement.y -= camera_speed * delta

  # When RMB is pressed, move camera by difference of mouse position
  if drag and __rmbk:
    camera_movement = _prev_mouse_pos - get_local_mouse_position()

  # Update position of the camera.
  position += camera_movement * get_zoom()

  # Set camera movement to zero, update old mouse position.
  camera_movement = Vector2(0,0)
  _prev_mouse_pos = get_local_mouse_position()

  var pre_clamp_pos = get_global_mouse_position()
  mouse_position = pre_clamp_pos

  _handle_shake()

func _input( event ):
  if event is InputEventMouseButton:
    if drag and\
       event.button_index == BUTTON_RIGHT:
      # Control by right mouse button.
      if event.pressed: __rmbk = true
      else: __rmbk = false
    # Check if mouse wheel was used. Not handled by ImputMap!
    if wheel:
      # Checking if future zoom won't be under 0.
      # In that cause engine will flip screen.
      print(wheel)
      print(camera_zoom)
      if event.button_index == BUTTON_WHEEL_UP and\
      camera_zoom.x - camera_zoom_speed.x > 0 and\
      camera_zoom.y - camera_zoom_speed.y > 0:
        camera_zoom -= camera_zoom_speed
        set_zoom(camera_zoom)
        # Checking if future zoom won't be above zoom_out_limit.
      if event.button_index == BUTTON_WHEEL_DOWN and\
      camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
      camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
        camera_zoom += camera_zoom_speed
        set_zoom(camera_zoom)

    if event.button_index == end_draw_arrow_key  and draw_arrow_mode == true:
      draw_arrow_mode = false
      game.get_node("Skill").use_skill(
        # 这里假定 Camera 只有玩家能用
        game.me,
        end_draw_arrow_action,
        {
          pos = mouse_position
        }
      )
      end_draw_arrow_action = null
      end_draw_arrow_key = null

  # Control the input of keyboard
  if event is InputEventKey:
    if event.pressed and event.scancode == KEY_SPACE:
      position = Vector2(0, 0)
    if event.pressed and event.scancode == end_draw_arrow_key  and draw_arrow_mode == true:
      draw_arrow_mode = false
      game.get_node("Skill").use_skill(
        # 这里假定 Camera 只有玩家能用
        game.me,
        end_draw_arrow_action,
        {
          pos = mouse_position
        }
      )
      end_draw_arrow_action = null
      end_draw_arrow_key = null



  # Control by keyboard handled by InpuMap.
  if event.is_action_pressed("ui_left"):
    __keys[0] = true
  if event.is_action_pressed("ui_up"):
    __keys[1] = true
  if event.is_action_pressed("ui_right"):
    __keys[2] = true
  if event.is_action_pressed("ui_down"):
    __keys[3] = true
  if event.is_action_released("ui_left"):
    __keys[0] = false
  if event.is_action_released("ui_up"):
    __keys[1] = false
  if event.is_action_released("ui_right"):
    __keys[2] = false
  if event.is_action_released("ui_down"):
    __keys[3] = false


var _me
func enter_draw_arrow_mode(action, action_key, me):
  draw_arrow_mode = true
  end_draw_arrow_action = action
  end_draw_arrow_key = action_key
  _me = me
  set_process(true)

func _draw():
  if draw_arrow_mode == true:
    var pos = mouse_position - self.position
    draw_line(- self.position, pos, Color(0.2, 0.8, 1), 1.5)
    if end_draw_arrow_action == Global.ESkill.ATK:
      _draw_circle_arc(pos, Global.attack_radius(_me), Color(0.2, 0.8, 1))

func _draw_circle_arc(center, radius, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(0 + i * 360 / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func shake_camera(offset: float):
  _shake_offset = offset

func _handle_shake():
  if _shake_offset > 0.00001:
    offset = Vector2(
      rand_range(-_shake_offset, _shake_offset),
      rand_range(-_shake_offset, _shake_offset)
    )
    _shake_offset *= 0.9
  else:
    _shake_offset = 0