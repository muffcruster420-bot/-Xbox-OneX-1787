extends Node2D

var hunter_tex = preload("res://hunter.jpg")
var deer_tex = preload("res://deer.jpg")
var bg_tex = preload("res://forest.jpg")

var player_pos := Vector2(640, 360)
var aim := Vector2(1, 0)
var bullets := []
var animals := []
var score := 0

func _ready():
    print("Xbox One X Hunting - loaded art")
    spawn_animal()

func _process(delta):
    # aim with right stick
    var rx = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
    var ry = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
    if Vector2(rx, ry).length() > 0.2:
        aim = Vector2(rx, ry).normalized()

    for b in bullets:
        b.pos += b.dir * 900 * delta
    for a in animals:
        a.pos += a.dir * 70 * delta

    # hits
    for b in bullets.duplicate():
        for a in animals.duplicate():
            if b.pos.distance_to(a.pos) < 45:
                bullets.erase(b)
                animals.erase(a)
                score += 1
                break
    queue_redraw()

func _draw():
    # background stretched to screen
    draw_texture_rect(bg_tex, Rect2(0,0,1280,720), false)
    # hunter (64x64)
    draw_texture_rect(hunter_tex, Rect2(player_pos - Vector2(32,32), Vector2(64,64)), false)
    # aim line
    draw_line(player_pos, player_pos + aim * 80, Color.RED, 3)
    # bullets
    for b in bullets:
        draw_circle(b.pos, 5, Color.YELLOW)
    # deer (96x96)
    for a in animals:
        draw_texture_rect(deer_tex, Rect2(a.pos - Vector2(48,48), Vector2(96,96)), false)
    # score
    draw_string(get_theme_default_font(), Vector2(30,50), "DEER: %d" % score, 0, -1, 32, Color.WHITE)

func _input(event):
    if event is InputEventJoypadButton and event.button_index == JOY_BUTTON_A and event.pressed:
        bullets.append({pos = player_pos + aim * 40, dir = aim})

func spawn_animal():
    var side = randi() % 4
    var pos = Vector2()
    match side:
        0: pos = Vector2(-60, randf_range(100,620))
        1: pos = Vector2(1340, randf_range(100,620))
        2: pos = Vector2(randf_range(100,1180), -60)
        3: pos = Vector2(randf_range(100,1180), 780)
    var dir = (player_pos - pos).normalized()
    animals.append({pos = pos, dir = dir})
    await get_tree().create_timer(3.0).timeout
    spawn_animal()
