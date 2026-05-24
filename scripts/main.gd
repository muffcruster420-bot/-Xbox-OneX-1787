extends Node2D

var player_pos := Vector2(640, 600)
var speed := 400
var enemies := []

func _ready():
    print("Xbox One X Model 1787 ready")
    # spawn first enemy
    spawn_enemy()

func _process(delta):
    # left stick movement
    var dir = Vector2(
        Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
        Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
    )
    player_pos += dir * speed * delta
    player_pos.x = clamp(player_pos.x, 0, 1280)
    player_pos.y = clamp(player_pos.y, 0, 720)
    
    # move enemies down
    for e in enemies:
        e.y += 200 * delta
    queue_redraw()

func _draw():
    # draw player (blue square)
    draw_rect(Rect2(player_pos - Vector2(25,25), Vector2(50,50)), Color.BLUE)
    # draw enemies (red)
    for e in enemies:
        draw_rect(Rect2(e - Vector2(20,20), Vector2(40,40)), Color.RED)

func spawn_enemy():
    enemies.append(Vector2(randi() % 1200 + 40, -40))
    await get_tree().create_timer(1.0).timeout
    spawn_enemy()

func _input(event):
    if event.is_action_pressed("ui_accept"):
        print("A pressed - restart")
        get_tree().reload_current_scene()
