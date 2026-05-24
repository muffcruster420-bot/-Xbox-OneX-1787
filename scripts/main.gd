extends Node2D

func _ready():
    print("Xbox One X Model 1787 ready")

func _input(event):
    if event.is_action_pressed("ui_accept"):
        print("A pressed")
    if event is InputEventJoypadButton and event.pressed:
        print("Controller button: ", event.button_index)
